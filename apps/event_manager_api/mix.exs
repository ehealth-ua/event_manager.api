defmodule EventManagerApi.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :event_manager_api,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      aliases: aliases(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto_trail],
      mod: {EventManagerApi.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_),     do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:confex, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:scrivener_ecto, "~> 1.2"},
      {:ecto_trail, "~> 0.2.3"},
      {:ecto_logger_json, "~> 0.1"},
      {:quantum, "~> 2.2"},
      {:ex_machina, "~> 2.1", only: :test},
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate",
        "run priv/repo/seeds.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": [
        "ecto.create",
        "ecto.migrate",
        "test"
      ]
    ]
  end
end
