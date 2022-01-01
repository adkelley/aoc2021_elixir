defmodule Day01 do
  @moduledoc """
  Part 1 - How many measurements are larger than the previous measurement?
  Part 2 - How many sums are larger than the previous sum?

  See https://adventofcode.com/2021/day/1
  """

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

def puzzle_input do
   "lib/day01_input.txt"
   |> File.read!()
end

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

      iex> Day01.part1
      7

  """
  def part1 do
    #@sample
    puzzle_input
    |> parse_input
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right > left end)
  end

  @doc """

  ## Examples
      iex> Day01.part2
      5

  """
  def part2 do
    #@sample
    puzzle_input
    |> parse_input
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [left, right] -> right > left end)
  end
end
