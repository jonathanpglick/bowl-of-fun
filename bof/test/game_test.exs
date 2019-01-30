defmodule GameTest do
  use ExUnit.Case
  doctest Bof.Game
  alias Bof.Game
  alias Bof.Game.Team

  def sample_game() do
    Game.new()
    |> Game.add_team("Team 1")
    |> Game.add_team("Team 2")
    |> Game.add_paper("dinosaur")
    |> Game.add_paper("chicken")
  end

  def apply_turn_ticks(game, turns) do
    Enum.reduce(turns..1, game, fn _i, game ->
      game
      |> Game.turn_tick()
    end)
  end

  test "start a game" do
    game = sample_game() |> Game.start()
    assert game.state == :active
    assert game |> Game.current_team() == %Team{name: "Team 1", score: 0}
  end

  test "start a game turn" do
    game = sample_game() |> Game.start() |> Game.turn_start()
    assert game.turn_state == :active
    assert game.turn_time_left == 60
  end

  test "remove a team" do
    game = sample_game() |> Game.remove_team("Team 2")
    assert game.teams == [%Team{name: "Team 1", score: 0}]

    game = sample_game() |> Game.remove_team("Team 1")
    assert game.teams == [%Team{name: "Team 2", score: 0}]
  end

  test "game turn tick" do
    game = sample_game() |> Game.start() |> Game.turn_start()

    game = game |> apply_turn_ticks(50)
    assert game.turn_time_left == 10
    game = game |> apply_turn_ticks(10)
    assert game.turn_time_left == 0
    game2 = game |> apply_turn_ticks(1)
    assert game !== game2
  end

  test "turn paper guessed" do
    game = sample_game() |> Game.start() |> Game.turn_start()
    game = game |> Game.paper_guessed()
    assert length(game.round_papers) == length(game.papers) - 1
  end

  test "round papers run out" do
    game = sample_game() |> Game.start()
    assert game.round == :taboo

    game =
      game
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()

    assert game.round == :charades

    game =
      game
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()

    assert game.round == :one_word
  end

  test "round ends new team turn" do
    game = sample_game() |> Game.start()
    team = game |> Game.current_team()

    game =
      game
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()

    assert Enum.at(game.teams, 0).score == 2
    team2 = game |> Game.current_team()
    assert team !== team2

    game =
      game
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()

    game = game |> Game.paper_guessed()
    game = game |> Game.paper_guessed()

    team3 = game |> Game.current_team()
    assert team.name === team3.name
    assert team3.score == 2
  end

  test "game completes" do
    game =
      sample_game()
      |> Game.start()
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()
      |> Game.turn_start()
      |> Game.paper_guessed()
      |> Game.paper_guessed()

    assert game.state == :finished
    assert game.teams |> Enum.at(0) |> Map.get(:score) == 4
    assert game.teams |> Enum.at(1) |> Map.get(:score) == 2
  end
end
