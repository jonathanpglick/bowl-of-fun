defmodule Bof do
  def new_game(callback_pid \\ nil) do
    {:ok, pid} =
      DynamicSupervisor.start_child(Bof.GameSupervisor, {Bof.GameProcess, [callback_pid]})

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
