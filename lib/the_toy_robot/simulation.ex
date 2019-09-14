defmodule TheToyRobot.Simulation do
  @max_x 4
  @max_y @max_x
  @xs 0..@max_x
  @ys 0..@max_y
  @x_strs Enum.map(@xs, &Integer.to_string/1)
  @y_strs Enum.map(@ys, &Integer.to_string/1)

  def run_command(state, "PLACE " <> xyf) do
    Regex.named_captures(
      ~r{\A(?<x>\d+),(?<y>\d+),(?<f>NORTH|EAST|SOUTH|WEST)\z},
      xyf
    )
    |> case do
      %{"x" => x, "y" => y, "f" => f} when x in @x_strs and y in @y_strs ->
        {String.to_integer(x), String.to_integer(y), f}

      _invalid_xyf ->
        state
    end
  end

  def run_command({x, y, "NORTH" = f}, "MOVE") when y < @max_y, do: {x, y + 1, f}
  def run_command({x, y, "EAST" = f}, "MOVE") when x < @max_x, do: {x + 1, y, f}
  def run_command({x, y, "SOUTH" = f}, "MOVE") when y > 0, do: {x, y - 1, f}
  def run_command({x, y, "WEST" = f}, "MOVE") when x > 0, do: {x - 1, y, f}

  def run_command({x, y, "NORTH"}, "LEFT"), do: {x, y, "WEST"}
  def run_command({x, y, "WEST"}, "LEFT"), do: {x, y, "SOUTH"}
  def run_command({x, y, "SOUTH"}, "LEFT"), do: {x, y, "EAST"}
  def run_command({x, y, "EAST"}, "LEFT"), do: {x, y, "NORTH"}

  def run_command({x, y, "NORTH"}, "RIGHT"), do: {x, y, "EAST"}
  def run_command({x, y, "EAST"}, "RIGHT"), do: {x, y, "SOUTH"}
  def run_command({x, y, "SOUTH"}, "RIGHT"), do: {x, y, "WEST"}
  def run_command({x, y, "WEST"}, "RIGHT"), do: {x, y, "NORTH"}

  def run_command({x, y, f} = state, "REPORT") do
    IO.puts("The robot is currently at #{x}, #{y} and it's facing #{f}.")
    state
  end

  def run_command(state, _unknown_command), do: state

  def run(commands), do: Enum.reduce(commands, nil, &run_command(&2, &1))
end
