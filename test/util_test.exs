defmodule KappaMetrics.UtilTest do
  use ExUnit.Case, async: true

  alias KappaMetrics.Util
  doctest Util

  test "transforming keys" do
    map  = %{"foo" => "bar"}
    keys = [:foo]
    assert Util.filter_with_atoms(map, keys) == %{foo: "bar"}
  end

  test "filtering other keys" do
    map  = %{"foo" => "bar", "baz" => "buz"}
    keys = [:foo]
    assert Util.filter_with_atoms(map, keys) == %{foo: "bar"}
  end

  test "empty arguments" do
    map = %{}
    keys = []
    assert map_size(Util.filter_with_atoms(map, keys)) == 0
  end
end
