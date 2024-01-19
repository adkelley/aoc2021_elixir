defmodule AocCli do
  @type day() :: String.t()
  @type input() :: String.t()
  @type session_cookie() :: String.t()
  @type solution() :: String.t()
  @type solutions() :: {solution(), solution()}
  @type puzzle() :: (String.t() -> String.t())
  @type puzzles() :: {puzzle(), puzzle()}
  @type reason() :: atom()
  @type error() :: {:error, reason() }
  @type ok_solutions() :: {:ok, solutions()}
  @type ok_puzzles() :: {:ok, puzzles()}
  @type ok_session_cookie() :: {:ok, session_cookie()}
  @type ok_input() :: {:ok, input()}
  @type ok()    :: {:ok, atom()}

  def usage() do
    """
    Advent of Code 2021

    Usage: aoc2021 <DAY> [options]

    <DAY> is a number from 1 to 25 representing the <DAY>'s programming puzzle result.

    The --help and --version options can be given instead of <DAY> for usage and versioning information
    """
  end

  @spec main(list()) :: :ok
  def main(args) do
    if unix?() do
      Application.put_env(:elixir, :ansi_enabled, true)
    end

    call(args)
  end

  defp call([arg]) when arg in ["--help", "-h"], do: display_help()
  defp call([arg]) when arg in ["--version", "-v"], do: display_version()

  @spec call(list()) :: :ok
  defp call([arg | _args]) do
    with {:ok, day} <- valid_day_arg?(arg),
         {:ok, solutions} <- find_solutions_for_day(day) do
      display_solutions_for_day(solutions, day)
    else
      {:error, reason} -> display_reason(reason, arg)
    end
  end

  defp call(_args), do: IO.write(usage())

  defp unix?(), do: match?({:unix, _}, :os.type())

  defp display_help() do
    IO.write(usage())
  end

  @app_version Mix.Project.config()[:version]

  defp display_version() do
    IO.puts(:erlang.system_info(:system_version))
    IO.puts("Elixir " <> System.build_info()[:build])
    IO.puts("\n Advent of Code 2021 #{@app_version}")
  end

  @invalid_day_arg :invalid_day_arg

  @spec valid_day_arg?(day()) :: ok() | error()
  defp valid_day_arg?(day) do
    if natural_number?(day) && advent_day?(day) do
      {:ok, day}
    else
      {:error, @invalid_day_arg}
    end
  end

  @spec natural_number?(day()) :: boolean()
  defp natural_number?(s) do
    String.to_charlist(s) |> Enum.map(fn c -> c > 47 && c < 58 end) |> Enum.all?()
  end

  @spec advent_day?(day()) :: boolean()
  defp advent_day?(day) do
    String.to_integer(day) |> Kernel.then(fn day -> day > 0 && day < 26 end)
  end

  @spec find_solutions_for_day(day()) :: ok_solutions() | error()
  defp find_solutions_for_day(day) do
    with {:ok, {f1, f2}} <- get_puzzle_fns(day),
         {:ok, input} <- load_input(day),
         {:ok, solutions} <- {:ok, {f1.(input), f2.(input)}} do
      {:ok, solutions}
    end
  end

  @missing_session_cookie :missing_session_cookie
  @failed_to_cache_input :failed_to_cache_input
  @day_not_implemented :day_not_implemented

  @spec display_reason(reason(), day()) :: :ok
  defp display_reason(reason, day) do
    case reason do
      @invalid_day_arg ->
        IO.ANSI.format([
          :red,
          "Invalid day argument '#{day}'. Choose a natural number from 1-25\n"
        ])
        |> IO.puts()

      @missing_session_cookie ->
        IO.ANSI.format([
          :red,
          "You have not exported your session cookie to an environment variable. Check the README for instructions.\n"
        ])
        |> IO.puts()

      @failed_to_cache_input ->
        IO.ANSI.format([
          :red,
          "Failed to save loaded input to cache directory. Check the README for instructions\n"
        ])
        |> IO.puts()

      @day_not_implemented ->
        IO.ANSI.format([:red, "The solution for day #{day} hasn't been implemented.\n"])
        |> IO.puts()

      _ ->
        IO.puts("Undefined Error")
    end
  end

  @aoc_year "2021"
  @spec display_solutions_for_day(solutions(), day()) :: :ok
  defp display_solutions_for_day({s1, s2}, day) do
    IO.puts("Advent of Code #{@aoc_year} solutions for day #{day}:")
    Util.insert_commas(s1) |> then(fn s -> IO.puts("Result for part 1: #{s}") end)
    Util.insert_commas(s2) |> then(fn s -> IO.puts("Result for part 2: #{s}") end)
  end

  @spec get_puzzle_fns(day()) :: ok_puzzles() | error()
  defp get_puzzle_fns(day) do
    case day do
      "1" -> {:ok, {&Day01.part1/1, &Day01.part2/1}}
      "2" -> {:ok, {&Day02.part1/1, &Day02.part2/1}}
      _ -> {:error, @day_not_implemented}
    end
  end

  @input_cache_dir ".input"
  @saved_puzzle_input :saved_puzzle_input

  @spec load_input(day()) :: ok_input() | error()
  defp load_input(day) do
    case load_input_from_cache(day) do
      {:ok, input} ->
        {:ok, input}

      _ ->
        with {:ok, @input_cache_dir} <- create_cache_dir_if_missing(),
             # get the input from the internet
             {:ok, input} <- fetch_input_from_internet(day),
             # Write it to the cache directory
             {:ok, @saved_puzzle_input} <- save_input_to_cache(day, input) do
          {:ok, input}
        end
    end
  end

  @input_file_ext ".aocinput"

  @spec input_filename(day()) :: String.t()
  defp input_filename(day), do: day <> @input_file_ext

  @spec load_input_from_cache(day()) :: {:ok, binary()} | error()
  defp load_input_from_cache(day) do
    path_to_file = Path.join([@input_cache_dir, input_filename(day)])
    File.read(path_to_file)
  end

  # This will create a local cache.  If the user wants a symbolic link to a
  # global cache, then they should create that link prior to running this cli
  @spec create_cache_dir_if_missing() :: ok() | error()
  defp create_cache_dir_if_missing() do
    if File.dir?(@input_cache_dir) do
      {:ok, @input_cache_dir}
    else
      case File.mkdir(@input_cache_dir) do
        :ok -> {:ok, @input_cache_dir}
        {:error, _} -> {:error, @failed_to_cache_input}
      end
    end
  end

  @spec fetch_input_from_internet(day()) :: ok_input() | error()
  defp fetch_input_from_internet(day) do
    with {:ok, session_cookie} <- load_session_cookie(),
         {:ok, input} <- fetch_input(session_cookie, day) do
      {:ok, input}
    end
  end

  @spec save_input_to_cache(day(), input()) :: ok() | error()
  defp save_input_to_cache(day, input) do
    cache_path = Path.join(@input_cache_dir, input_filename(day))

    case File.write(cache_path, input) do
      :ok -> {:ok, @saved_puzzle_input}
      _ -> {:error, @failed_to_cache_input}
    end
  end

  @session_env_var "ADVENT_OF_CODE_SESSION_COOKIE"

  @spec load_session_cookie() :: ok_session_cookie() | error()
  defp load_session_cookie() do
    if session_cookie = System.get_env(@session_env_var) do
      {:ok, session_cookie}
    else
      {:error, @missing_session_cookie}
    end
  end

  @spec fetch_input(session_cookie(), day()) :: ok() | error()
  defp fetch_input(session_cookie, day) do
    url = "https://adventofcode.com/#{@aoc_year}/day/#{day}/input"

    headers = [
      {~c"user-agent", ~c"github.com/adkelley/aoc2021_elixir"},
      {~c"cookie", String.to_charlist("session=#{session_cookie}")}
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      _ ->
        IO.puts("Nothing matches\n")
    end
  end
end
