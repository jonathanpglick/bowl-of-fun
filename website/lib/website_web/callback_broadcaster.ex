defmodule WebsiteWeb.CallbackBroadcaster do
  @moduledoc """
  Module recieves `:changed` callbacks from the game processes and forwards
  the message to the game channels.
  """
  use GenServer

  # Outside API.
  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Inside API.
  def init(args) do
    {:ok, args}
  end

  def handle_info({:changed, game}, _state) do
    WebsiteWeb.GameChannel.broadcast_changed(game)
    {:noreply, nil}
  end
end
