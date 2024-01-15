defmodule Day02Test do
  use ExUnit.Case, async: true

  import Day02

  @sample """
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  """

  test "part1" do
    assert part1(@sample) === "150"
  end

  test "part2" do
    assert part2(@sample) === "900"
  end
end
