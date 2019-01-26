defmodule Bof.Game.Team do
  @derive Jason.Encoder
  defstruct(
    name: nil,
    score: 0
  )
end
