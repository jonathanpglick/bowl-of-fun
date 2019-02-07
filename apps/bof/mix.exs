defmodule Game.MixProject do
  use Mix.Project

  def project do
    [
      app: :bof,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Bof.Application, []}
    ]
  end

  defp deps do
    [
      {:shortcode, in_umbrella: true},
      {:jason, "~> 1.1"}
    ]
  end
end
