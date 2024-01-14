defmodule Day02 do
  @moduledoc """
  Part 1 - Calculate the horizontal position and depth you would have after following the planned course.
  What do you get if you multiply your final horizontal position by your final depth?

  Part 2 - Incorporating the aim value, What do you get if you multiply your final horizontal position
  by your final depth?

  See https://adventofcode.com/2021/day/2
  """

  @sample """
  forward 5
  down 5
  forward 8
  up 3
  down 8
  forward 2
  """

  def puzzle_input() do
    "lib/day02_input.txt"
    |> File.read!()
  end

  @doc """
  :input "forward 9\nforward 7\n..."
  :output [:forward 9, forward 7, ...]
  """

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "forward " <> number -> {:forward, String.to_integer(number)}
      "down " <> number -> {:down, String.to_integer(number)}
      "up " <> number -> {:up, String.to_integer(number)}
    end)
  end

  @doc """
  :input [:forward 9, forward 7, ...]
  :output x = position * depth
  """

<<<<<<< HEAD
  def part1 do
    # @sample
    puzzle_input()
=======
  def part1(input) do
    # @sample
    input
>>>>>>> Refactor-main
    |> parse_input()
    |> Enum.reduce({_position = 0, _depth = 0}, fn
      {:forward, value}, {depth, position} -> {depth, position + value}
      {:up, value}, {depth, position} -> {depth - value, position}
      {:down, value}, {depth, position} -> {depth + value, position}
    end)
    |> then(fn {position, depth} -> position * depth end)
    |> then(fn d -> Integer.to_string(d) end)
  end

  @doc """
  :input [:forward 9, forward 7, ...]
  :output x = position * depth
  """

<<<<<<< HEAD
  def part2 do
    # @sample
    puzzle_input()
=======
  def part2(input) do
    # @sample
    input
>>>>>>> Refactor-main
    |> parse_input()
    |> Enum.reduce({_position = 0, _depth = 0, _aim = 0}, fn
      {:forward, value}, {depth, position, aim} -> {depth + aim * value, position + value, aim}
      {:up, value}, {depth, position, aim} -> {depth, position, aim - value}
      {:down, value}, {depth, position, aim} -> {depth, position, aim + value}
    end)
    |> then(fn {position, depth, _} -> position * depth end)
    |> then(fn d -> Integer.to_string(d) end)
  end
end

ExUnit.start()

defmodule Day02Test do
  use ExUnit.Case

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

ExUnit.start()

defmodule Day02Test do
  use ExUnit.Case

  import Day02

  test "part1" do
    assert part1() === 1_882_980
  end

  test "part2" do
    assert part2() === 1_971_232_560
  end
end
