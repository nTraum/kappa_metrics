defmodule KappaMetrics.Measurements.Stream do
  defstruct name:         nil,
            online:       false,
            delay:        nil,
            game:         nil,
            video_height: nil,
            viewers:      nil,
            average_fps:  nil

  def fetch_from_api(name) do
    response = KappaMetrics.Rest.Streams.get!(name)

    response.body
    |> handle_response
    |> Map.put(:name, name)
  end

  defp handle_response(data) when is_nil(data) do
    %{online: false}
  end

  defp handle_response(data) when is_map(data) do
    Map.put(data, :online, true)
  end
end
