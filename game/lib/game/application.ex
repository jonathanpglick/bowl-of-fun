defmodule Game.Application do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      worker(Game.Server, [])
    ]

    opts = [
      name: Game.Supervisor,
      strategy: :simple_one_for_one
    ]

    Supervisor.start_link(children, opts)
  end
end
