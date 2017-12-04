defmodule EventManagerWeb.Mixfile do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :event_manager_web,
      version: @version,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      test_coverage: [tool: ExCoveralls],
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {EventManagerWeb, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:confex, "~> 3.2"},
      {:phoenix, "~> 1.3.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:eview, "~> 0.12.2"},
      {:cowboy, "~> 1.1"},
      {:plug_logger_json, "~> 0.5"},
      {:event_manager_api, in_umbrella: true},
    ]
  end
end
