defmodule Bof do
  @game_registry Bof.GameRegistry

  def new_game(callback_pid \\ nil) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        Bof.GameSupervisor,
        {Bof.GameProcess, [callback_pid]}
      )

    GenServer.call(pid, {:external_state})
    |> Map.get(:shortcode)
  end

  def game_exists?(shortcode) do
    case Registry.lookup(@game_registry, shortcode) do
      [] -> false
      _ -> true
    end
  end

  def add_team(%{shortcode: shortcode}, team_name), do: add_team(shortcode, team_name)

  def add_team(shortcode, team_name) do
    via_tuple(shortcode)
    |> safe_call({:add_team, team_name})
  end

  def add_paper(%{shortcode: shortcode}, paper), do: add_paper(shortcode, paper)

  def add_paper(shortcode, paper) do
    via_tuple(shortcode)
    |> safe_call({:add_paper, paper})
  end

  def can_start?(%{shortcode: shortcode}), do: can_start?(shortcode)

  def can_start?(shortcode) do
    via_tuple(shortcode)
    |> safe_call({:can_start?})
  end

  def start(%{shortcode: shortcode}), do: start(shortcode)

  def start(shortcode) do
    via_tuple(shortcode)
    |> safe_call({:start})
  end

  def turn_start(%{shortcode: shortcode}), do: turn_start(shortcode)

  def turn_start(shortcode) do
    via_tuple(shortcode)
    |> safe_call({:turn_start})
  end

  def paper_guessed(%{shortcode: shortcode}), do: paper_guessed(shortcode)

  def paper_guessed(shortcode) do
    via_tuple(shortcode)
    |> safe_call({:paper_guessed})
  end

  def state(%{shortcode: shortcode}), do: state(shortcode)

  def state(shortcode) do
    via_tuple(shortcode)
    |> safe_call({:external_state})
  end

  def via_tuple(shortcode) do
    {:via, Registry, {@game_registry, shortcode}}
  end

  @doc """
  Wraps calls to `GenServer.call()` to catch the `exit()` if the called process
  doesn't exist.
  """
  def safe_call(server, request) do
    try do
      GenServer.call(server, request)
    catch
      :exit, reason ->
        IO.inspect(reason)
        {:error, "Game not found"}
    end
  end
end
