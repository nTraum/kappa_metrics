defmodule KappaMetrics.Rest.Channels do
  @moduledoc """
  Represents the Twitch REST API v3 'channels' endpoint.
  """

  use HTTPoison.Base
  alias HTTPoison.Response
  alias HTTPoison.Error


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

  def fetch(name) do
    case get(name) do
      {:ok, %Response{status_code: 200, body: nil}} ->
        {:error, "Empty response for #{name}"}
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, response: body}
      {:ok, %Response{status_code: status_code}} ->
        {:error, "Unexpected HTTP response code for #{name}, code: #{status_code}"}
      {:error, %Error{reason: reason}} ->
        {:error, "HTTP error for #{name}, reason: #{reason}"}
    end
  end

end
