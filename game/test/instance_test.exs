defmodule GameInstanceTest do
  use ExUnit.Case
  doctest Game.Instance
  alias Game.Instance.Team

  def sample_game() do
    Game.Instance.new()
    |> Game.Instance.add_team("Team 1")
    |> Game.Instance.add_team("Team 2")
    |> Game.Instance.add_paper("dinosaur")
    |> Game.Instance.add_paper("chicken")
  end

  def apply_turn_ticks(game, turns) do
    Enum.reduce(turns..1, game, fn _i, game ->
      game
      |> Game.Instance.turn_tick()
    end)
  end

  test "start a game" do
    game = sample_game() |> Game.Instance.start()
    assert game.state == :active
    assert game |> Game.Instance.current_team() == %Team{name: "Team 1", score: 0}
  end

  test "start a game turn" do
    game = sample_game() |> Game.Instance.start() |> Game.Instance.turn_start()
    assert game.turn_state == :active
    assert game.turn_time_left == 60
  end

  test "game turn tick" do
    game = sample_game() |> Game.Instance.start() |> Game.Instance.turn_start()

    game = game |> apply_turn_ticks(50)
    assert game.turn_time_left == 10
    game = game |> apply_turn_ticks(10)
    assert game.turn_time_left == 0
    game2 = game |> apply_turn_ticks(1)
    assert game !== game2
  end

  test "turn paper guessed" do
    game = sample_game() |> Game.Instance.start() |> Game.Instance.turn_start()
    game = game |> Game.Instance.turn_paper_guessed()
    assert length(game.round_papers) == length(game.papers) - 1
  end

  test "round papers run out" do
    game = sample_game() |> Game.Instance.start()
    assert game.round == :taboo

    game =
      game
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()

    assert game.round == :charades

    game =
      game
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()

    assert game.round == :one_word
  end

  test "round ends new team turn" do
    game = sample_game() |> Game.Instance.start()
    team = game |> Game.Instance.current_team()

    game =
      game
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()

    assert Enum.at(game.teams, 0).score == 2
    team2 = game |> Game.Instance.current_team()
    assert team !== team2

    game =
      game
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()

    game = game |> Game.Instance.turn_paper_guessed()
    game = game |> Game.Instance.turn_paper_guessed()

    team3 = game |> Game.Instance.current_team()
    assert team.name === team3.name
    assert team3.score == 2
  end

  test "game completes" do
    game =
      sample_game()
      |> Game.Instance.start()
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_start()
      |> Game.Instance.turn_paper_guessed()
      |> Game.Instance.turn_paper_guessed()

    assert game.state == :finished
    assert game.teams |> Enum.at(0) |> Map.get(:score) == 4
    assert game.teams |> Enum.at(1) |> Map.get(:score) == 2
  end
end
