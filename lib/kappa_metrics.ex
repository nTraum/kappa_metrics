defmodule KappaMetrics do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([KappaMetrics.InfluxDb.child_spec], strategy: :one_for_one)

    children = [
      supervisor(KappaMetrics.ApiPoller.Supervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KappaMetrics.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
