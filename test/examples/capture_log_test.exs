defmodule TestingExamples.CaptureLogTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog
  require Logger

  test "capture log" do
    assert capture_log(fn ->
             Logger.error("log msg")
           end) =~ "log msg"
  end

  test "check multiple captures concurrently" do
    fun = fn ->
      for msg <- ["hello", "hi"] do
        assert capture_log(fn -> Logger.error(msg) end) =~ msg
      end

      Logger.warn("testing")
    end

    assert capture_log(fun) =~ "hello"
    assert capture_log([level: :warn], fun) =~ "testing"
  end

  test "assert_raise squashes exceptions" do
    assert_raise ArithmeticError, ~r/with an error/, fn ->
      raise ArithmeticError, "with an error"
    end
  end
end
