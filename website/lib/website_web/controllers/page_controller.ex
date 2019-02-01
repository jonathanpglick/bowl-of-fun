defmodule WebsiteWeb.PageController do
  use WebsiteWeb, :controller

  @callback_broadcaster WebsiteWeb.CallbackBroadcaster

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def join_game(conn, params) do
    shortcode = Map.get(params, "shortcode") |> String.downcase()
    redirect(conn, to: Routes.page_path(conn, :game_page, shortcode))
  end

  def new_game(conn, _params) do
    shortcode = Bof.new_game(@callback_broadcaster)
    redirect(conn, to: Routes.page_path(conn, :game_page, shortcode))
  end

  def game_page(conn, params) do
    shortcode = Map.get(params, "shortcode") |> String.downcase()
    game_page(conn, params, Bof.state(shortcode))
  end

  def game_page(conn, _params, {:error, _reason}) do
    conn |> game_not_found()
  end

  def game_page(conn, _params, game) do
    uid = conn.req_cookies["_website_key"]
    render(conn, "game_page.html", game: game, uid: uid)
  end

  def game_not_found(conn) do
    conn
    |> put_flash(:error, "Game not found")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
