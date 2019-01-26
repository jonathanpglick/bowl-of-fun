defmodule WebsiteWeb.Router do
  use WebsiteWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", WebsiteWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    post("/", PageController, :join_game)
    post("/new", PageController, :new_game)
    get("/game/:shortcode", PageController, :game_page)
  end
end
