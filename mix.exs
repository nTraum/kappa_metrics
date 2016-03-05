defmodule KappaMetrics.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kappa_metrics,
      version: "0.0.1",
      elixir: "~> 1.2",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test],
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [
        :httpoison,
        :instream,
        :logger
      ],
      mod: {KappaMetrics, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 0.8.0"},
      {:instream,  "~> 0.10"},
      {:poison,    "~> 1.4.0"},
      {:exrm,      "~> 1.0.2"},

      {:excoveralls, "~> 0.5", only: :test},
      {:credo,       "~> 0.3.5", only: [:dev, :test]}
    ]
  end
end
