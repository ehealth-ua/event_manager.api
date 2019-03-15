defmodule Core.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :core,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8.1",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :ecto_trail],
      mod: {Core.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:confex_config_provider, "~> 0.1.0"},
      {:confex, "~> 3.4"},
      {:postgrex, "~> 0.14.1"},
      {:ecto_sql, "~> 3.0.5"},
      {:scrivener_ecto, git: "https://github.com/AlexKovalevych/scrivener_ecto.git", branch: "fix_page_number"},
      {:ehealth_logger, git: "https://github.com/edenlabllc/ehealth_logger.git"},
      {:ecto_trail, "~> 0.4.1"},
      {:quantum, "~> 2.3"},
      {:ex_machina, "~> 2.2", only: :test}
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
      test: [
        "ecto.create",
        "ecto.migrate",
        "test"
      ]
    ]
  end
end
