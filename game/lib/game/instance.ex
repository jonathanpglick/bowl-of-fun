defmodule Game.Instance do
  alias Game.Instance.Team

  defstruct(
    callback_pid: nil,
    # | :active | :finished
    state: :initializing,
    teams: [],
    current_team_index: 0,
    papers: [],
    # | :charades | :one_word
    round: :taboo,
    round_papers: [],
    # | :active | :complete
    turn_state: :pending,
    turn_time_left: 60
  )

  def new(callback_pid \\ nil) do
    %Game.Instance{
      callback_pid: callback_pid
    }
  end

  def add_team(game = %Game.Instance{teams: teams}, team_name) do
    %Game.Instance{
      game
      | teams: teams ++ [%Team{name: team_name}]
    }
  end

  def current_team(game) do
    game.teams
    |> Enum.at(game.current_team_index)
  end

  def add_paper(game = %Game.Instance{papers: papers}, paper) do
    %Game.Instance{
      game
      | papers: papers ++ [paper]
    }
  end

  def can_start?(%Game.Instance{papers: papers, teams: teams})
      when length(papers) > 0 and length(teams) > 0,
      do: true

  def can_start?(_), do: false

  def start(game = %Game.Instance{papers: papers, teams: teams})
      when length(papers) > 0 and length(teams) > 0 do
    %Game.Instance{
      game
      | state: :active,
        current_team_index: 0,
        round_papers: Enum.shuffle(papers)
    }
  end

  def start(game = %Game.Instance{}) do
    game
  end

  def turn_start(game = %Game.Instance{turn_state: :pending}) do
    %Game.Instance{game | turn_state: :active, turn_time_left: 60}
  end

  def turn_tick(game = %Game.Instance{turn_time_left: 0}) do
    turn_over(game)
  end

  def turn_tick(game = %Game.Instance{turn_time_left: turn_time_left}) do
    %Game.Instance{game | turn_time_left: turn_time_left - 1}
  end

  def turn_paper_guessed(game = %Game.Instance{round_papers: [_], turn_state: :active}) do
    game
    |> Map.put(:round_papers, [])
    |> current_team_add_score(1)
    |> turn_over()
  end

  def turn_paper_guessed(
        game = %Game.Instance{round_papers: [_ | next_papers], turn_state: :active}
      ) do
    game
    |> Map.put(:round_papers, next_papers)
    |> current_team_add_score(1)
  end

  def turn_paper_guessed(game = %Game.Instance{}) do
    game
  end

  defp turn_over(game = %Game.Instance{}) do
    game = game |> Map.put(:turn_state, :complete)

    case round_over?(game) do
      true ->
        case game_over?(game) do
          true -> game |> game_over()
          false -> game |> round_next() |> turn_next()
        end

      false ->
        game |> turn_next()
    end
  end

  defp round_over?(%Game.Instance{round_papers: []}), do: true
  defp round_over?(%Game.Instance{}), do: false

  defp round_next(game = %Game.Instance{round: :taboo, papers: papers}) do
    %Game.Instance{game | round: :charades, round_papers: Enum.shuffle(papers)}
  end

  defp round_next(game = %Game.Instance{round: :charades, papers: papers}) do
    %Game.Instance{game | round: :one_word, round_papers: Enum.shuffle(papers)}
  end

  defp round_next(game = %Game.Instance{}) do
    game
  end

  defp turn_next(game = %Game.Instance{}) do
    game
    |> Map.put(:current_team_index, turn_next_index(game))
    |> Map.put(:turn_state, :pending)
  end

  defp turn_next_index(%Game.Instance{current_team_index: index, teams: teams})
       when index + 1 >= length(teams),
       do: 0

  defp turn_next_index(%Game.Instance{current_team_index: index}), do: index + 1

  defp game_over?(%Game.Instance{round: :one_word, round_papers: []}), do: true
  defp game_over?(%Game.Instance{state: :finished}), do: true
  defp game_over?(_game), do: false

  defp game_over(game = %Game.Instance{}) do
    %Game.Instance{game | state: :finished}
  end

  defp current_team_add_score(game = %Game.Instance{}, points_to_add) do
    team = game |> current_team() |> Map.update(:score, 0, &(&1 + points_to_add))
    %Game.Instance{game | teams: List.replace_at(game.teams, game.current_team_index, team)}
  end
end
