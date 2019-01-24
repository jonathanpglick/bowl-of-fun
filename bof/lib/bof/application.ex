defmodule Bof.Application do
  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Bof.GameSupervisor}
    ]

    opts = [
      name: Bof.Supervisor,
      strategy: :one_for_one
    ]

    Supervisor.start_link(children, opts)
  end
end
