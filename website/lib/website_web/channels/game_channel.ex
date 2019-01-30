defmodule WebsiteWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> shortcode, _, socket) do
    socket = socket |> assign(:shortcode, shortcode)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    game =
      socket.assigns.shortcode
      |> Bof.state()

    push(socket, "STATE", game)

    {:noreply, socket}
  end

  def handle_in("STATE", _, socket) do
    game =
      socket.assigns.shortcode
      |> Bof.state()

    push(socket, "STATE", game)

    {:noreply, socket}
  end

  def handle_in("ADD_TEAM", team_name, socket) do
    socket.assigns.shortcode
    |> Bof.add_team(team_name)
    |> broadcast_changed()

    {:noreply, socket}
  end

  def broadcast_changed(game) do
    WebsiteWeb.Endpoint.broadcast!("game:#{game.shortcode}", "CHANGED", game)
  end
end
