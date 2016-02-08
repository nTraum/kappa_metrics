defmodule KappaMetrics.Rest.Channels do
  @moduledoc """
  Represents the Twitch REST API v3 'channels' endpoint.
  """

  use HTTPoison.Base

  @doc """
  Returns the full HTTP API URL for the given channel.

  ## Examples
      iex> KappaMetrics.Rest.Channels.process_url("rocketbeanstv")
      "https://api.twitch.tv/kraken/channels/rocketbeanstv"
  """
  def process_url(name) do
    "https://api.twitch.tv/kraken/channels/" <> name
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end
end
