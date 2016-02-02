defmodule KappaMetrics.Rest.Streams do
  use HTTPoison.Base

  def process_url(name) do
    "https://api.twitch.tv/kraken/streams/" <> name
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.get("stream")
  end
end
