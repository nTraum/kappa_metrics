defmodule KappaMetrics.Series.Channel do
  use Instream.Series

  alias KappaMetrics.Util
  alias KappaMetrics.InfluxDb

  series do
    database    :kappa_metrics
    measurement :channels

    field       :followers
    field       :views

    tag         :name
    tag         :game
    tag         :status
  end

  def write(name) do
    name
    |> fetch_data
    |> create_measurement
    |> InfluxDb.write
  end

  def fetch_data(name) do
    KappaMetrics.Rest.Channels.get!(name).body
  end

  def create_measurement(data) do
    fields = Util.filter_with_atoms(data, [:followers, :views])
    tags   = Util.filter_with_atoms(data, [:name, :game, :status])

    point = %KappaMetrics.Series.Channel{}
    point = %{ point | fields: %{ point.fields | followers: Map.fetch!(fields, :followers) } }
    point = %{ point | fields: %{ point.fields | views: Map.fetch!(fields, :views) } }

    point = %{ point | tags: %{ point.tags | name: Map.fetch!(tags, :name) } }
    point = %{ point | tags: %{ point.tags | game: Map.fetch!(tags, :game) } }
    %{ point | tags: %{ point.tags | status: Map.fetch!(tags, :status) } }
  end
end
