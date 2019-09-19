defmodule T.Cartesian do
  @moduledoc false

  @doc """
  Cartesian product of two lists

  ## Examples

    iex> T.Cartesian.product([1, 2], ["a", "b"])
    [[a: 1, b: "a"], [a: 1, b: "b"], [a: 2, b: "a"], [a: 2, b: "b"]]
    
    iex> T.Cartesian.product([], ["a", "b", "c"])
    []
  """
  @spec product([any()], [any()]) :: [[a: any(), b: any()]]
  def product(a, b) when is_list(a) and is_list(b) do
    for i <- a, j <- b, do: [a: i, b: j]
  end
end
