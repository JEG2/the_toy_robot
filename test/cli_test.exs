defmodule TheToyRobot.CLITest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
  alias TheToyRobot.CLI

  test "the CLI reads from the passed file" do
    output =
      capture_io(fn ->
        CLI.main([Path.expand("support/fixtures/commands.txt", __DIR__)])
      end)

    assert String.match?(output, ~r{1,\s*2.+\bNORTH\b})
  end

  test "exactly one argument is required" do
    output =
      capture_io(fn ->
        CLI.main([])
      end)

    assert String.match?(output, ~r{\AUSAGE:})
  end
end
