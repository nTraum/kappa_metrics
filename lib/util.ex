defmodule KappaMetrics.Util do
  @moduledoc """
  Module for generic utility & helper functions.
  """

  @doc """
  Converts a map with string keys to atom keys and filters them based on a list of atoms.

  Returns a map.

  ## Examples
      iex> KappaMetrics.Util.filter_with_atoms(%{"foo" => 1, "bar" => 2, "baz" => 3}, [:foo, :bar])
      %{foo: 1, bar: 2}

  """
  @spec filter_with_atoms(%{String.t => any}, [atom]) :: %{atom => any}
  def filter_with_atoms(map, keys) do
    tuples = keys |> Enum.map(fn key -> to_string(key) end) |> Enum.zip(keys)
    for {string_key, atom_key} <- tuples,
        Map.has_key?(map, string_key),
        into: %{},
        do: {atom_key, Map.fetch!(map, string_key)}
  end
end
