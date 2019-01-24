defmodule Shortcode.Worker do
  use GenServer
  @me __MODULE__
  @coder Hashids.new()

  # Outside API.
  def start_link(_arg) do
    GenServer.start_link(__MODULE__, 0, name: @me)
  end

  def get_next() do
    GenServer.call(@me, {:get_next})
  end

  # Inside API.
  def init(index) do
    {:ok, index}
  end

  def handle_call({:get_next}, _from, index) do
    shortcode = Hashids.encode(@coder, index)
    {:reply, shortcode, index + 1}
  end
end
