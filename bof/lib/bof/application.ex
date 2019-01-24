defmodule Bof.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Bof.GameSupervisor},
      {Registry, name: Bof.GameRegistry, keys: :unique, strategy: :one_for_one}
    ]

    opts = [
      name: Bof.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, opts)
  end
end
