defmodule Shortcode.Application do
  use Application

  def start(_type, _args) do
    children = [
      Shortcode.Worker
    ]

    opts = [strategy: :one_for_one, name: Shortcode.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
