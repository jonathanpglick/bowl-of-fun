defmodule Game do
  def new_game() do
    {:ok, pid} = Supervisor.start_child(Games.Supervisor, [])
    pid
  end

  def add_team(game_pid, team_name) do
    GenServer.call(game_pid, {:add_team, team_name})
  end

  def add_paper(game_pid, paper) do
    GenServer.call(game_pid, {:add_paper, paper})
  end

  def can_start?(game_pid) do
    GenServer.call(game_pid, {:can_start?})
  end

  def start(game_pid) do
    GenServer.call(game_pid, {:start})
  end

  def turn_start(game_pid) do
    GenServer.call(game_pid, {:turn_start})
  end

  def paper_guessed(game_pid) do
    GenServer.call(game_pid, {:paper_guessed})
  end

  def state(game_pid) do
    GenServer.call(game_pid, {:external_state})
  end
end
