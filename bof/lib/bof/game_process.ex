defmodule Bof.GameProcess do
  use GenServer
  alias Bof.Game

  @game_registry Bof.GameRegistry

  # Outside API.
  def start_link([callback_pid]) do
    shortcode = Shortcode.get_next()
    GenServer.start_link(__MODULE__, [shortcode, callback_pid], name: via_tuple(shortcode))
  end

  def via_tuple(shortcode) do
    {:via, Registry, {@game_registry, shortcode}}
  end

  # Inside API.
  def init([shortcode, callback_pid]) do
    {:ok, Game.new(shortcode, callback_pid)}
  end

  def handle_call({:add_team, team_name}, _from, game) do
    game
    |> Game.add_team(team_name)
    |> send_changed()
    |> handle_call_return()
  end

  def handle_call({:add_paper, paper}, _from, game) do
    game
    |> Game.add_paper(paper)
    |> send_changed()
    |> handle_call_return()
  end

  def handle_call({:can_start?}, _from, game) do
    {:reply, Game.can_start?(game), game}
  end

  def handle_call({:start}, _from, game) do
    game
    |> Game.start()
    |> send_changed()
    |> handle_call_return()
  end

  def handle_call({:turn_start}, _from, game) do
    game
    |> Game.turn_start()
    |> send_changed()
    |> set_tick()
    |> handle_call_return()
  end

  def handle_call({:paper_guessed}, _from, game) do
    game
    |> Game.paper_guessed()
    |> send_changed()
    |> handle_call_return()
  end

  def handle_call({:external_state}, _from, game) do
    game |> handle_call_return()
  end

  def handle_info({:turn_tick}, game) do
    game =
      game
      |> Game.turn_tick()
      |> send_changed()
      |> set_tick()

    {:noreply, game}
  end

  def handle_call_return(game) do
    {:reply, game_to_external_state(game), game}
  end

  def send_changed(game = %{callback_pid: callback_pid}) when callback_pid != nil do
    send(callback_pid, {:changed, game_to_external_state(game)})
    game
  end

  def send_changed(game), do: game

  defp game_to_external_state(game) do
    %{
      shortcode: game.shortcode,
      teams: game.teams,
      current_team: game |> Game.current_team(),
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
