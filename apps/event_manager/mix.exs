defmodule EventManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :event_manager,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8.1",
      test_coverage: [tool: ExCoveralls],
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {EventManager, []},
      extra_applications: [:logger]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:eview, "~> 0.15.0"},
      {:plug_cowboy, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:jason, "~> 1.1"},
      {:core, in_umbrella: true}
    ]
  end

  defp aliases do
    [
      "ecto.setup": &ecto_setup/1
    ]
  end

  defp ecto_setup(_) do
    Mix.shell().cmd("cd ../core && mix ecto.setup")
  end
end
