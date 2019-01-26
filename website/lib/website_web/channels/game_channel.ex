defmodule WebsiteWeb.GameChannel do
  use Phoenix.Channel

  def join("game:" <> shortcode, _, socket) do
    socket = socket |> assign(:shortcode, shortcode)
    {:ok, socket}
  end

  def handle_in("state", _, socket) do
    game = Bof.state(socket.assigns.shortcode)
    push(socket, "changed", game)
    {:noreply, socket}
  end

  def handle_in("add_team", team_name, socket) do
    shortcode = socket.assigns.shortcode
    game = Bof.add_team(shortcode, team_name)
    push(socket, "changed", game)
    {:noreply, socket}
  end
end
