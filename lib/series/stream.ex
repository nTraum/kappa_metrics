defmodule KappaMetrics.Series.Stream do
  use Instream.Series

  alias KappaMetrics.Util

  series do
    database    "kappa_metrics"
    measurement "streams"

    field       :delay
    field       :video_height
    field       :viewers
    field       :average_fps

    tag         :name
    tag         :game
  end

  def new(response, name) do
    fields = Util.filter_with_atoms(response, [:delay, :video_height, :viewers, :average_fps]) |> ensure_float
    tags   = Util.filter_with_atoms(response, [:game])

    measurement = %KappaMetrics.Series.Stream{}
    measurement = %{ measurement | fields: %{ measurement.fields | delay: fields[:delay] } }
    measurement = %{ measurement | fields: %{ measurement.fields | video_height: fields[:video_height] } }
    measurement = %{ measurement | fields: %{ measurement.fields | viewers: fields[:viewers] } }
    measurement = %{ measurement | fields: %{ measurement.fields | average_fps: fields[:average_fps] } }

    measurement = %{ measurement | tags: %{ measurement.tags | name: name } }
    %{ measurement | tags: %{ measurement.tags | game: tags[:game] } }
  end

  # The Twitch Rest API sometimes returns the average FPS as a float and sometimes as an integer.
  # Because InfluxDB errors when trying to insert a float value into a measurement that contains integers already
  # (or vice versa), we always cast the value to a float.
  defp ensure_float(fields) do
    Map.update!(fields, :average_fps, &(&1 / 1))
  end
end
