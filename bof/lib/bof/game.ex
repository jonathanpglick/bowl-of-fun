defmodule Bof.Game do
  alias __MODULE__
  alias Bof.Game.Team

  defstruct(
    callback_pid: nil,
    shortcode: nil,
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
    turn_time_left: 60,
    turn_started_by: nil
  )

  def new(shortcode \\ nil, callback_pid \\ nil) do
    %Game{
      callback_pid: callback_pid,
      shortcode: shortcode
    }
  end

  def play_again(game = %Game{}) do
    %Game{
      callback_pid: game.callback_pid,
      shortcode: game.shortcode,
      teams: Enum.map(game.teams, fn team -> %Team{name: team.name} end)
    }
  end

  def add_team(game = %Game{teams: teams, state: :initializing}, team_name) do
    %Game{
      game
      | teams: teams ++ [%Team{name: team_name}]
    }
  end

  def remove_team(game = %Game{teams: teams, state: :initializing}, team_name) do
    %Game{
      game
      | teams: List.delete(teams, %Team{name: team_name})
    }
  end

  def current_team(game) do
    game.teams
    |> Enum.at(game.current_team_index)
  end

  def add_paper(game = %Game{papers: papers, state: :initializing}, paper) do
    paper = String.trim(paper)

    case String.length(paper) do
      0 ->
        game

      _ ->
        %Game{
          game
          | papers: papers ++ [paper]
        }
    end
  end

  def add_paper(game = %Game{}, _paper) do
    game
  end

  def can_start?(%Game{papers: papers, teams: teams})
      when length(papers) > 0 and length(teams) > 0,
      do: true

  def can_start?(_), do: false

  def start(game = %Game{papers: papers, teams: teams})
      when length(papers) > 0 and length(teams) > 0 do
    %Game{
      game
      | state: :active,
        current_team_index: 0,
        round_papers: Enum.shuffle(papers)
    }
  end

  def start(game = %Game{}) do
    game
  end

  def turn_start(game = %Game{turn_state: :pending}, started_by \\ nil) do
    %Game{game | turn_state: :active, turn_time_left: 60, turn_started_by: started_by}
  end

  def turn_tick(game = %Game{turn_time_left: 0}) do
    turn_over(game)
  end

  def turn_tick(game = %Game{turn_time_left: turn_time_left}) do
    %Game{game | turn_time_left: turn_time_left - 1}
  end

  def paper_guessed(game = %Game{round_papers: [_], turn_state: :active}) do
    game
    |> Map.put(:round_papers, [])
    |> current_team_add_score(1)
    |> turn_over()
  end

  def paper_guessed(game = %Game{round_papers: [_ | next_papers], turn_state: :active}) do
    game
    |> Map.put(:round_papers, next_papers)
    |> current_team_add_score(1)
  end

  def paper_guessed(game = %Game{}) do
    game
  end

  defp turn_over(game = %Game{}) do
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

  defp round_over?(%Game{round_papers: []}), do: true
  defp round_over?(%Game{}), do: false

  defp round_next(game = %Game{round: :taboo, papers: papers}) do
    %Game{game | round: :charades, round_papers: Enum.shuffle(papers)}
  end

  defp round_next(game = %Game{round: :charades, papers: papers}) do
    %Game{game | round: :one_word, round_papers: Enum.shuffle(papers)}
  end

  defp round_next(game = %Game{}) do
    game
  end

  defp turn_next(game = %Game{}) do
    game
    |> Map.put(:current_team_index, turn_next_index(game))
    |> Map.put(:turn_state, :pending)
  end

  defp turn_next_index(%Game{current_team_index: index, teams: teams})
       when index + 1 >= length(teams),
       do: 0

  defp turn_next_index(%Game{current_team_index: index}), do: index + 1

  defp game_over?(%Game{round: :one_word, round_papers: []}), do: true
  defp game_over?(%Game{state: :finished}), do: true
  defp game_over?(_game), do: false

  defp game_over(game = %Game{}) do
    %Game{game | state: :finished}
  end

  defp current_team_add_score(game = %Game{}, points_to_add) do
    team = game |> current_team() |> Map.update(:score, 0, &(&1 + points_to_add))
    %Game{game | teams: List.replace_at(game.teams, game.current_team_index, team)}
  end
end
