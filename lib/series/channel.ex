defmodule KappaMetrics.Series.Channel do
  use Instream.Series

  alias KappaMetrics.Util

  series do
    database    "kappa_metrics"
    measurement "channels"

    field       :followers
    field       :views

    tag         :name
    tag         :game
    tag         :status
  end

  def new(data) do
    fields = Util.filter_with_atoms(data, [:followers, :views])
    tags   = Util.filter_with_atoms(data, [:name, :game, :status])

    point = %KappaMetrics.Series.Channel{}
    point = %{ point | fields: %{ point.fields | followers: fields[:followers] } }
    point = %{ point | fields: %{ point.fields | views: fields[:views] } }

    point = %{ point | tags: %{ point.tags | name: tags[:name] } }
    point = %{ point | tags: %{ point.tags | game: tags[:game] } }
    %{ point | tags: %{ point.tags | status: tags[:status] } }
  end
end
