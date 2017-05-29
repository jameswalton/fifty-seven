defmodule Tip.CalculatorTest do
  use ExUnit.Case, async: true

  import Tip.Calculator
  import ExUnit.CaptureIO

  doctest Tip.Calculator

  describe "get_amount/1 with valid input" do
    test "with integer string" do
      capture_io("10", fn ->
        assert 10.0 = get_amount("Enter bill amount:")
      end)
    end

    test "with float string" do
      capture_io("bad_input\nbad_input_again\n11.1", fn ->
        assert 11.1 = get_amount("Enter bill amount:")
      end)
    end
  end

  describe "get_amount/1 with invalid input" do
    test "with negative input" do
      capture_io("-1\n9.9", fn ->
        assert 9.9 = get_amount("Enter bill amount:")
      end)
    end
  end

  describe "validate_amount/1" do
    test "with positive float" do
      assert {:ok, 1.1} = validate_amount(1.1)
    end

    test "with zero float" do
      assert {:ok, 0.0} = validate_amount(0.0)
    end

    test "with negative float" do
      assert {:error, :invalid_input} = validate_amount(-1.0)
    end

    test "with positive integer" do
      assert {:error, :invalid_input} = validate_amount(1)
    end

    test "with negative integer" do
      assert {:error, :invalid_input} = validate_amount(-1)
    end
  end

  describe "parse_gets/1" do
    test "returns float given valid input" do
      assert 1.0 = parse_gets("1")
    end

    test "returns negative float given valid input" do
      assert -0.1 = parse_gets("-0.1")
    end

    test "returns an error given invalid input" do
      assert :error = parse_gets("bob")
    end
  end

  describe "run/0" do
    test "prompts for input and returns result" do
      assert capture_io([input: "11.1\n11.2", capture_prompt: true], fn ->
        run()
      end) == "Enter bill amount:Enter tip percentage:Tip: 1.25\nTotal: 12.35\n"
    end
  end

  describe "calculate/2 with valid input" do
    test "with float input values returns floats" do
      assert {:ok, %{tip: 1.69, total: 12.94}} = calculate(11.25, 15.0)
    end
  end

  describe "calculate/2 with invalid input" do
    test "with non-float input values returns an invalid input error" do
      assert {:error, :invalid_input} = calculate("wat", "wat")
    end
  end
end
