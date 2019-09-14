defmodule TheToyRobot.SimulationTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  alias TheToyRobot.Simulation

  test "command before PLACE are ignored" do
    assert Simulation.run_command(nil, "MOVE") == nil
  end

  test "PLACE puts the robot at X, Y facing F" do
    assert Simulation.run_command(nil, "PLACE 0,0,SOUTHWEST") == nil
    assert Simulation.run_command(nil, "PLACE 0,9,WEST") == nil

    assert Simulation.run_command(nil, "PLACE 0,0,NORTH") == {0, 0, "NORTH"}
    assert Simulation.run_command(nil, "PLACE 1,2,EAST") == {1, 2, "EAST"}
  end

  test "MOVE pushes the robot one unit in the direction it is facing" do
    assert Simulation.run_command({1, 1, "NORTH"}, "MOVE") == {1, 2, "NORTH"}
    assert Simulation.run_command({1, 1, "EAST"}, "MOVE") == {2, 1, "EAST"}
    assert Simulation.run_command({1, 1, "SOUTH"}, "MOVE") == {1, 0, "SOUTH"}
    assert Simulation.run_command({1, 1, "WEST"}, "MOVE") == {0, 1, "WEST"}
  end

  test "movement off the table is ignored" do
    assert Simulation.run_command({1, 4, "NORTH"}, "MOVE") == {1, 4, "NORTH"}
    assert Simulation.run_command({4, 1, "EAST"}, "MOVE") == {4, 1, "EAST"}
    assert Simulation.run_command({1, 0, "SOUTH"}, "MOVE") == {1, 0, "SOUTH"}
    assert Simulation.run_command({0, 1, "WEST"}, "MOVE") == {0, 1, "WEST"}
  end

  test "LEFT rotates facing 90 degrees left" do
    assert Simulation.run_command({0, 0, "NORTH"}, "LEFT") == {0, 0, "WEST"}
    assert Simulation.run_command({0, 0, "WEST"}, "LEFT") == {0, 0, "SOUTH"}
    assert Simulation.run_command({0, 0, "SOUTH"}, "LEFT") == {0, 0, "EAST"}
    assert Simulation.run_command({0, 0, "EAST"}, "LEFT") == {0, 0, "NORTH"}
  end

  test "RIGHT rotates facing 90 degrees right" do
    assert Simulation.run_command({0, 0, "NORTH"}, "RIGHT") == {0, 0, "EAST"}
    assert Simulation.run_command({0, 0, "EAST"}, "RIGHT") == {0, 0, "SOUTH"}
    assert Simulation.run_command({0, 0, "SOUTH"}, "RIGHT") == {0, 0, "WEST"}
    assert Simulation.run_command({0, 0, "WEST"}, "RIGHT") == {0, 0, "NORTH"}
  end

  test "REPORT announces the location and facing of the robot" do
    output =
      capture_io(fn ->
        assert Simulation.run_command({1, 4, "EAST"}, "REPORT") == {1, 4, "EAST"}
      end)

    assert String.match?(output, ~r{1,\s*4.+\bEAST\b})

    output =
      capture_io(fn ->
        assert Simulation.run_command({0, 0, "SOUTH"}, "REPORT") == {0, 0, "SOUTH"}
      end)

    assert String.match?(output, ~r{0,\s*0.+\bSOUTH\b})
  end

  test "can run multiple commands" do
    assert Simulation.run([
             "PLACE 0,0,NORTH",
             "MOVE",
             "RIGHT",
             "MOVE",
             "LEFT",
             "MOVE",
             "MOVE",
             "LEFT",
             "MOVE",
             "RIGHT",
             "RIGHT",
             "MOVE",
             "MOVE",
             "MOVE"
           ]) == {3, 3, "EAST"}
  end
end
