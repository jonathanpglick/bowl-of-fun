defmodule Shortcode.MixProject do
  use Mix.Project

  def project do
    [
      app: :shortcode,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Shortcode.Application, []}
    ]
  end

  defp deps do
    [
      {:hashids, "~> 2.0"}
    ]
  end
end
