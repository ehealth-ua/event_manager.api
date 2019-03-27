defmodule EventManagerAPI.MixProject do
  use Mix.Project

  @version "0.11.0"
  def project do
    [
      version: @version,
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:git_ops, "~> 0.6.0", only: [:dev]},
      {:distillery, "~> 2.0.12", runtime: false},
      {:excoveralls, "~> 0.8.1", only: [:dev, :test]},
      {:credo, "~> 1.0", only: [:dev, :test]}
    ]
  end
end
