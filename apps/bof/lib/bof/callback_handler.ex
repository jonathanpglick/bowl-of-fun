defmodule Bof.CallbackHandler do
  @moduledoc """
  Module used to test receiving the `:changed` callbacks being sent to a pid
  """
  use GenServer

  # Outside API.
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, [])
  end

  # Inside API.
  def init(_arg) do
    {:ok, nil}
  end

  def handle_info({:changed, game}, state) do
    IO.inspect("tick")
    IO.inspect(game)

    {:noreply, state}
  end
end
