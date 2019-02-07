defmodule WebsiteWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel("game:*", WebsiteWeb.GameChannel)

  def connect(params, socket, _connect_info) do
    socket = socket |> assign(:uid, params["uid"])
    {:ok, socket}
  end

  def id(_socket), do: nil
end
