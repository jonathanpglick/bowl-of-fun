defmodule Game.Server do
  use GenServer

  # Outside API.
  def start_link(callback_pid) do
    GenServer.start_link(__MODULE__, callback_pid)
  end

  # Inside API.
  def init(callback_pid) do
    {:ok, Game.Instance.new(callback_pid)}
  end

  def handle_call({:add_team, team_name}, _from, game) do
    game
    |> Game.Instance.add_team(team_name)
    |> handle_call_return()
  end

  def handle_call({:add_paper, paper}, _from, game) do
    game
    |> Game.Instance.add_paper(paper)
    |> handle_call_return()
  end

  def handle_call({:can_start?}, _from, game) do
    {:reply, Game.Instance.can_start?(game), game}
  end

  def handle_call({:start}, _from, game) do
    game
    |> Game.Instance.start()
    |> handle_call_return()
  end

  def handle_call({:turn_start}, _from, game) do
    game
    |> Game.Instance.turn_start()
    |> set_tick()
    |> handle_call_return()
  end

  def handle_call({:paper_guessed}, _from, game) do
    game
    |> Game.Instance.paper_guessed()
    |> handle_call_return()
  end

  def handle_call({:external_state}, _from, game) do
    game |> handle_call_return()
  end

  def handle_info({:turn_tick}, game) do
    game =
      game
      |> Game.Instance.turn_tick()
      |> set_tick()

    {:noreply, game}
  end

  def handle_call_return(game) do
    {:reply, game_to_external_state(game), game}
  end

  defp game_to_external_state(game) do
    %{
      teams: game.teams,
      current_team: game |> Game.Instance.current_team(),
      round: game.round,
      current_paper: game |> current_paper(),
      state: game.state,
      turn_state: game.turn_state,
      turn_time_left: game.turn_time_left
    }
  end

  defp current_paper(%{round_papers: []}), do: nil
  defp current_paper(%{round_papers: [current_paper]}), do: current_paper
  defp current_paper(%{round_papers: [current_paper | _]}), do: current_paper

  defp set_tick(game = %{turn_state: :active}) do
    Process.send_after(self(), {:turn_tick}, 1000)
    game
  end

  defp set_tick(game), do: game
end
