defmodule Day01 do
  @moduledoc """
  Part 1 - How many measurements are larger than the previous measurement?
  Part 2 - How many sums are larger than the previous sum?

  See https://adventofcode.com/2021/day/1
  """

  @doc """
   :input "199 200 ... 
   :output [199, 200, ...]
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """

  ## Examples

      iex> Day01.part1(input)
      7

  """
  def part1(input) do
    input
    |> parse_input()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right > left end)
    |> Integer.to_string()
  end

  @doc """

  ## Examples
      iex> Day01.part2(input)
      5

  """
  def part2(input) do
    input
    |> parse_input()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right > left end)
    |> Integer.to_string()
  end
end

ExUnit.start()

defmodule Day01Test do
  use ExUnit.Case

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

  test "part1" do
    assert part1(@sample) === "7"
  end

  test "part2" do
    assert part2(@sample) === "5"
  end
end
