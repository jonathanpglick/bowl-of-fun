defmodule Website.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(WebsiteWeb.Endpoint, []),
      worker(WebsiteWeb.CallbackBroadcaster, [], name: WebsiteWeb.CallbackBroadcaster)
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Website.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WebsiteWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
