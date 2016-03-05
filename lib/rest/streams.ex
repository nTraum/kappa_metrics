defmodule KappaMetrics.Rest.Streams do
  @moduledoc """
  Represents the Twitch REST API v3 'streams' endpoint.
  """

  use HTTPoison.Base
  alias HTTPoison.Response
  alias HTTPoison.Error

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
  end

  def fetch(name) do
    case get(name) do
      {:ok, %Response{status_code: 200, body: nil}} ->
        {:error, "Empty response for #{name}"}
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, response: body, name: name}
      {:ok, %Response{status_code: status_code}} ->
        {:error, "Unexptected HTTP response code for #{name}, code: #{status_code}"}
      {:error, %Error{reason: reason}} ->
        {:error, "HTTP error for #{name}, reason: #{reason}"}
    end
  end
end
