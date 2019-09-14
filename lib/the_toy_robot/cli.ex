defmodule TheToyRobot.CLI do
  alias TheToyRobot.Simulation

  def main(args) do
    with {:ok, input} <- prepare_input(args) do
      Simulation.run(input)
    else
      {:error, :expected_one_path_arg} ->
        IO.puts("USAGE:  the_toy_robot FILE_PATH")
    end
  end

  def prepare_input([path]) do
    {:ok, path |> File.stream!() |> Stream.map(&String.trim/1)}
  end

  def prepare_input(_invalid_args), do: {:error, :expected_one_path_arg}
end
