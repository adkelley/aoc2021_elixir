# Advent of Code 2021

My solutions to the Advent of Code 2021 in Elixir

See [Advent of Code 2021](https://adventofcode.com/)

## Build the Project
```
$ mix escript.build
```

## Usage
```
$ aoc_cli <DAY> [options]
```
`<DAY>` is a number from 1 to 25 representing the `<DAY>`'s programming puzzle result.

The `--help` and `--version` options can be given instead of `<DAY>` for usage and versioning information

## Advent of Code Session Cooke
In order to be able to download the puzzle data, `aoc_cli` requires that you set an environment variable containg your Advent of Code Session Cookie.  Here's how to get your session cookie:

1. Login on [Advent of Code](https://adventofcode.com/)
2. Open browser's developer console (e.g. right click --> Inspect) and navigate to the Network tab
3. GET any input page, say adventofcode.com/2021/day/1/input, and look in the request headers.
It's a long hex string. Export that to an environment variable `AOC_SESSION_COOKIE`. 
