defmodule KappaMetrics.ApiPoller.PeriodicWorker do
  require Logger

  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init(state) do
    reschedule
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.info(to_string(__MODULE__) <> " started")
    KappaMetrics.Series.Stream.write("rocketbeanstv")
    KappaMetrics.Series.Channel.write("rocketbeanstv")
    Logger.info(to_string(__MODULE__) <> " finished")
    reschedule

    {:noreply, state}
  end

  defp reschedule do
    Process.send_after(self(), :work, 30 * 1000)
  end
end
