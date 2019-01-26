defmodule WebsiteWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> shortcode, _, socket) do
    socket = socket |> assign(:shortcode, shortcode)
    {:ok, socket}
  end

  def handle_in("state", _, socket) do
    socket.assigns.shortcode
    |> Bof.state()

    {:noreply, socket}
  end

  def handle_in("add_team", team_name, socket) do
    socket.assigns.shortcode
    |> Bof.add_team(team_name)

    {:noreply, socket}
  end

  def broadcast_changed(game) do
    WebsiteWeb.Endpoint.broadcast!("game:#{game.shortcode}", "changed", game)
  end
end
