defmodule T.CartesianTest do
  use ExUnit.Case
  doctest T.Cartesian

  test "regular cartesian" do
    assert T.Cartesian.product([1, 2], ["f", "k"]) ==
             [
               [a: 1, b: "f"],
               [a: 1, b: "k"],
               [a: 2, b: "f"],
               [a: 2, b: "k"]
             ]
  end

  test "with empty args" do
    assert T.Cartesian.product([], ["f", "k"]) == []
    assert T.Cartesian.product([1, 2], []) == []
    assert T.Cartesian.product([], []) == []
  end
end
