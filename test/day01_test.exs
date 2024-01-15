defmodule Day01Test do
  use ExUnit.Case, async: true

  import Day01

  @sample """
  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  """

  @tag :skip
  test "part1" do
    assert part1(@sample) === "7"
  end

  @tag :skip
  test "part2" do
    assert part2(@sample) === "5"
  end
end
