defmodule KappaMetrics.ApiPoller.PeriodicWorker do
  require Logger

  alias KappaMetrics.InfluxDb
  alias KappaMetrics.Rest.Channels
  alias KappaMetrics.Rest.Streams
  alias KappaMetrics.Series.Channel
  alias KappaMetrics.Series.Stream


  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    reschedule
    {:ok, []}
  end

  def handle_info(:work, state) do
    Logger.info("Start")
    refresh_stream("rocketbeanstv")
    refresh_channel("rocketbeanstv")
    Logger.info("Done")
    reschedule
    {:noreply, state}
  end

  defp reschedule do
    Process.send_after(self(), :work, 30 * 1000)
  end

  defp refresh_channel(name) do
    case Channels.fetch(name) do
      {:ok, response: response} ->
        :ok = Channel.new(response) |> InfluxDb.write
      {:error, message} ->
        Logger.warn(message)
    end
  end

  defp refresh_stream(name) do
    case Streams.fetch(name) do
      {:ok, response: response, name: name} ->
        :ok = Stream.new(response, name) |> InfluxDb.write
      {:error, message} ->
        Logger.warn(message)
    end
  end
end
