defmodule Aoc2021.MixProject do
  use Mix.Project

  @description "Solve the Advent of Code 2021 problems"
  @version "0.1.0"

  def project do
    [
      app: :aoc_cli,
      description: @description,
      version: @version,
      elixir: "~> 1.16.0",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp escript do
    [
      main_module: AocCli,
      include_executables: true,
      include_erts: true
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:httpoison, "~> 2.2"}
    ]
  end
end
