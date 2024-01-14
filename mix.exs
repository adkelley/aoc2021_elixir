defmodule Aoc2021.MixProject do
  use Mix.Project

  @description "Solve the Advent of Code 2021 problems"
  @version "0.1.0"

  def project do
    [
      app: :aoc_2021,
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
      main_module: Aoc2021,
<<<<<<< HEAD
      app: nil
=======
      include_executables: true,
      include_erts: true
>>>>>>> Refactor-main
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
<<<<<<< HEAD
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false}
=======
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:httpoison, "~> 2.2"}
>>>>>>> Refactor-main
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
