defmodule TestingExamples.MixProject do
  use Mix.Project

  def project do
    [
      app: :testing_examples,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TestingExamples.Application, []}
    ]
  end

  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate"], "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:assertions, "~> 0.19.0", only: :test},
      {:ecto, "3.8.4"},
      {:ecto_sql, "3.8.3"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:jason, "~> 1.3"},
      {:mox, "~> 1.0", only: :test},
      {:plug_cowboy, "~> 2.5.2"},
      {:postgrex, "~> 0.16"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
