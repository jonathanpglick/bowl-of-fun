defmodule Bof.Game do
  alias Bof.Game.Team

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
    %Bof.Game{
      callback_pid: callback_pid
    }
  end

  def add_team(game = %Bof.Game{teams: teams}, team_name) do
    %Bof.Game{
      game
      | teams: teams ++ [%Team{name: team_name}]
    }
  end

  def current_team(game) do
    game.teams
    |> Enum.at(game.current_team_index)
  end

  def add_paper(game = %Bof.Game{papers: papers}, paper) do
    %Bof.Game{
      game
      | papers: papers ++ [paper]
    }
  end

  def can_start?(%Bof.Game{papers: papers, teams: teams})
      when length(papers) > 0 and length(teams) > 0,
      do: true

  def can_start?(_), do: false

  def start(game = %Bof.Game{papers: papers, teams: teams})
      when length(papers) > 0 and length(teams) > 0 do
    %Bof.Game{
      game
      | state: :active,
        current_team_index: 0,
        round_papers: Enum.shuffle(papers)
    }
  end

  def start(game = %Bof.Game{}) do
    game
  end

  def turn_start(game = %Bof.Game{turn_state: :pending}) do
    %Bof.Game{game | turn_state: :active, turn_time_left: 60}
  end

  def turn_tick(game = %Bof.Game{turn_time_left: 0}) do
    turn_over(game)
  end

  def turn_tick(game = %Bof.Game{turn_time_left: turn_time_left}) do
    %Bof.Game{game | turn_time_left: turn_time_left - 1}
  end

  def paper_guessed(game = %Bof.Game{round_papers: [_], turn_state: :active}) do
    game
    |> Map.put(:round_papers, [])
    |> current_team_add_score(1)
    |> turn_over()
  end

  def paper_guessed(game = %Bof.Game{round_papers: [_ | next_papers], turn_state: :active}) do
    game
    |> Map.put(:round_papers, next_papers)
    |> current_team_add_score(1)
  end

  def paper_guessed(game = %Bof.Game{}) do
    game
  end

  defp turn_over(game = %Bof.Game{}) do
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

  defp round_over?(%Bof.Game{round_papers: []}), do: true
  defp round_over?(%Bof.Game{}), do: false

  defp round_next(game = %Bof.Game{round: :taboo, papers: papers}) do
    %Bof.Game{game | round: :charades, round_papers: Enum.shuffle(papers)}
  end

  defp round_next(game = %Bof.Game{round: :charades, papers: papers}) do
    %Bof.Game{game | round: :one_word, round_papers: Enum.shuffle(papers)}
  end

  defp round_next(game = %Bof.Game{}) do
    game
  end

  defp turn_next(game = %Bof.Game{}) do
    game
    |> Map.put(:current_team_index, turn_next_index(game))
    |> Map.put(:turn_state, :pending)
  end

  defp turn_next_index(%Bof.Game{current_team_index: index, teams: teams})
       when index + 1 >= length(teams),
       do: 0

  defp turn_next_index(%Bof.Game{current_team_index: index}), do: index + 1

  defp game_over?(%Bof.Game{round: :one_word, round_papers: []}), do: true
  defp game_over?(%Bof.Game{state: :finished}), do: true
  defp game_over?(_game), do: false

  defp game_over(game = %Bof.Game{}) do
    %Bof.Game{game | state: :finished}
  end

  defp current_team_add_score(game = %Bof.Game{}, points_to_add) do
    team = game |> current_team() |> Map.update(:score, 0, &(&1 + points_to_add))
    %Bof.Game{game | teams: List.replace_at(game.teams, game.current_team_index, team)}
  end
end
