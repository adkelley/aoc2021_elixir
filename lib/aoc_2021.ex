defmodule Aoc2021 do
  def usage() do
    """
    Advent of Code 2021

    Usage: aoc2021 <DAY> [options]

    <DAY> is a number from 1 to 25 representing the <DAY>'s programming puzzle result.

    The --help and --version options can be given instead of <DAY> for usage and versioning information
    """
  end

  # import Day01, only: [part1: 1, part2: 1]
  # import Day02, only: [part1: 1, part2: 1]

  @spec main(list()) :: :ok
  def main(args) do
    if unix?() do
      Application.put_env(:elixir, :ansi_enabled, true)
    end

    call(args)
  end

  defp call([arg]) when arg in ["--help", "-h"], do: display_help()
  defp call([arg]) when arg in ["--version", "-v"], do: display_version()

  # TODO: Break this down further
  @invalid_day_arg :invalid_day_arg

  defp call([day | _args]) do
    with true <- natural_number?(day),
         true <- advent_day?(day),
         {:ok, {f1, f2}} <- get_solve_fns(day),
         {:ok, input} <- load_input(day),
         {:ok, {s1, s2}} <- {:ok, {f1.(input), f2.(input)}} do
      display_solution(s1, s2, day)
    else
      false -> display_reason(@invalid_day_arg)
      {:error, reason} -> display_reason(reason, day)
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

  @spec natural_number?(String.t()) :: boolean()
  defp natural_number?(s) do
    String.to_charlist(s) |> Enum.map(fn c -> c > 47 && c < 58 end) |> Enum.all?()
  end

  @spec advent_day?(String.t()) :: boolean()
  defp advent_day?(day) do
    String.to_integer(day) |> Kernel.then(fn day -> day > 0 && day < 26 end)
  end

  @missing_session_token :missing_session_token
  @failed_to_cache_input :failed_to_cache_input

  defp display_reason(reason) do
    case reason do
      @invalid_day_arg ->
        IO.ANSI.format([:red, "The day argument must be a natural number from 1-25\n"])
        |> IO.puts()

      @missing_session_token ->
        IO.ANSI.format([
          :red,
          "You have not exported your session token to an environment variable, check the README for instructions\n"
        ])
        |> IO.puts()

      @failed_to_cache_input ->
        IO.ANSI.format([
          :red,
          "Failed to save loaded input to cache directory, check the README for instructions\n"
        ])
        |> IO.puts()

      _ ->
        IO.puts("Undefined Error")
    end
  end

  @day_not_implemented :day_not_implemented
  defp display_reason(reason, day) do
    case reason do
      @day_not_implemented ->
        IO.ANSI.format([:red, "The solution for day #{day} hasn't been implemented.\n"])
        |> IO.puts()

      _ ->
        IO.inspect(reason)
    end

    IO.write(usage())
  end

  @aoc_year "2021"
  defp display_solution(s1, s2, day) do
    IO.puts("Advent of Code #{@aoc_year} solutions for day #{day}:")
    IO.puts("Result for part 1: #{s1}")
    IO.puts("Result for part 2: #{s2}")
  end

  @spec get_solve_fns(String.t()) :: {atom(), tuple() | atom()}
  defp get_solve_fns(day) do
    case day do
      "1" -> {:ok, {&Day01.part1/1, &Day01.part2/1}}
      "2" -> {:ok, {&Day02.part1/1, &Day02.part2/1}}
      _ -> {:error, @day_not_implemented}
    end
  end


  defp load_input(day) do
    case load_input_from_cache(day) do
      {:ok, input} -> {:ok, input}

      _ ->
        with :ok <- create_cache_dir_if_missing(),
             # get the input from the internet
             {:ok, input} <- fetch_input_from_internet(day),
             # Write it to the cache directory
             :ok <- save_input_to_cache(day, input) do
          {:ok, input}
        end
    end
  end

  @input_cache_dir ".input"
  @input_file_ext ".aocinput"

  defp input_filename(day), do: day <> @input_file_ext

  @spec load_input_from_cache(String.t()) :: {atom(), String.t() | atom()}
  defp load_input_from_cache(day) do
    path_to_file = Path.join([@input_cache_dir, input_filename(day)])
    File.read(path_to_file)
  end

  # This will create a local cache.  If the user wants a symbolic link to a
  # global cache, then they should create that prior to running this cli
  defp create_cache_dir_if_missing() do
    if File.dir?(@input_cache_dir) do
      :ok
    else
      File.mkdir(@input_cache_dir)
    end
  end

  defp fetch_input_from_internet(day) do
    with {:ok, session_token} <- load_session_token(),
         {:ok, input} <- fetch_input(session_token, day) do
      {:ok, input}
    end
  end


  defp save_input_to_cache(day, input) do
    cache_path = Path.join(@input_cache_dir, input_filename(day))

    if :ok = File.write(cache_path, input) do
      :ok
    else
      {:error, @failed_to_cache_input}
    end
  end

  @session_env_var "ADVENT_OF_CODE_SESSION_TOKEN"

  @spec load_session_token() :: tuple()
  defp load_session_token() do
    if session_token = System.get_env(@session_env_var) do
      {:ok, session_token}
    else
      {:error, @missing_session_token}
    end
  end

  defp fetch_input(session_token, day) do
    url = "https://adventofcode.com/#{@aoc_year}/day/#{day}/input"
    # url = "http://example.com"
    headers = [
      {~c"cookie", String.to_charlist("session=#{session_token}")}
    ]

    # case :httpc.request(
    #        :get,
    #        {~c"https://adventofcode.com/#{@aoc_year}/day/#{day}/input", headers},
    #        [],
    #        []
    #      ) do
    #   {:ok, {{~c"HTTP/1.1", 200, ~c"OK"}, _, input}} -> {:ok, input}
    #   {:error, _} -> {:error, "Bad HTTP Request"}
    # end

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
