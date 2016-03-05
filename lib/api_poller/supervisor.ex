defmodule KappaMetrics.ApiPoller.Supervisor do
  use Supervisor

  alias KappaMetrics.ApiPoller.PeriodicWorker

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(PeriodicWorker, [PeriodicWorker])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
