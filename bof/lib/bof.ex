defmodule Bof do
  def new_game(callback_pid \\ nil) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        Bof.GameSupervisor,
        {Bof.GameProcess, [callback_pid]}
      )

    GenServer.call(pid, {:external_state})
    |> Map.get(:shortcode)
  end

  def add_team(%{shortcode: shortcode}, team_name), do: add_team(shortcode, team_name)

  def add_team(shortcode, team_name) do
    via_tuple(shortcode)
    |> GenServer.call({:add_team, team_name})
  end

  def add_paper(%{shortcode: shortcode}, paper), do: add_paper(shortcode, paper)

  def add_paper(shortcode, paper) do
    via_tuple(shortcode)
    |> GenServer.call({:add_paper, paper})
  end

  def can_start?(%{shortcode: shortcode}), do: can_start?(shortcode)

  def can_start?(shortcode) do
    via_tuple(shortcode)
    |> GenServer.call({:can_start?})
  end

  def start(%{shortcode: shortcode}), do: start(shortcode)

  def start(shortcode) do
    via_tuple(shortcode)
    |> GenServer.call({:start})
  end

  def turn_start(%{shortcode: shortcode}), do: turn_start(shortcode)

  def turn_start(shortcode) do
    via_tuple(shortcode)
    |> GenServer.call({:turn_start})
  end

  def paper_guessed(%{shortcode: shortcode}), do: paper_guessed(shortcode)

  def paper_guessed(shortcode) do
    via_tuple(shortcode)
    |> GenServer.call({:paper_guessed})
  end

  def state(%{shortcode: shortcode}), do: state(shortcode)

  def state(shortcode) do
    via_tuple(shortcode)
    |> GenServer.call({:external_state})
  end

  def via_tuple(shortcode) do
    {:via, Registry, {Bof.GameRegistry, shortcode}}
  end
end
