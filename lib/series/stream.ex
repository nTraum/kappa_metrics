defmodule KappaMetrics.Series.Stream do
  use Instream.Series

  alias KappaMetrics.Util
  alias KappaMetrics.InfluxDb

  series do
    database    :kappa_metrics
    measurement :streams

    field       :online
    field       :delay
    field       :video_height
    field       :viewers
    field       :average_fps

    tag         :name
    tag         :game
  end

  def write(name) do
    name
    |> fetch_data
    |> create_measurement
    |> InfluxDb.write
  end

  def fetch_data(name) do
    response = KappaMetrics.Rest.Streams.get!(name)
    response.body |> Map.put("name", name)
  end

  def create_measurement(data) do
    fields = Util.filter_with_atoms(data, [:online, :delay, :video_height, :viewers, :average_fps])
    tags   = Util.filter_with_atoms(data, [:name, :game])

    point = %KappaMetrics.Series.Stream{}
    point = %{ point | fields: %{ point.fields | online: fields[:online] } }
    point = %{ point | fields: %{ point.fields | delay: fields[:delay] } }
    point = %{ point | fields: %{ point.fields | video_height: fields[:video_height] } }
    point = %{ point | fields: %{ point.fields | viewers: fields[:viewers] } }
    point = %{ point | fields: %{ point.fields | average_fps: fields[:average_fps] } }

    point = %{ point | tags: %{ point.tags | name: tags[:name] } }
    %{ point | tags: %{ point.tags | game: tags[:game] } }
  end
end
