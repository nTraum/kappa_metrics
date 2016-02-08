defmodule KappaMetrics.Rest.Streams do
  @moduledoc """
  Represents the Twitch REST API v3 'streams' endpoint.
  """

  use HTTPoison.Base

  @doc """
  Returns the full HTTP API URL for the given stream.

  ## Examples
      iex> KappaMetrics.Rest.Streams.process_url("rocketbeanstv")
      "https://api.twitch.tv/kraken/streams/rocketbeanstv"
  """
  def process_url(name) do
    "https://api.twitch.tv/kraken/streams/" <> name
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.get("stream")
    |> add_online_status
  end

  defp add_online_status(data) when is_nil(data) do
    %{"online" => false}
  end

  defp add_online_status(data) when is_map(data) do
    Map.put(data, "online", true)
  end
end
