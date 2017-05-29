defmodule Tip.Calculator do
  require Logger

  @doc """
  Calculates the total amount based on a tip percentage.

    iex> calculate(100.0, 10.0)
    {:ok, %{tip: 10.0, total: 110.0}}

    iex> calculate("bad", "input")
    {:error, :invalid_input}
  """
  def calculate(bill_amount, tip_rate) when is_float(bill_amount) and is_float(tip_rate) do
    tip_amount = bill_amount * (tip_rate / 100)
    tip_amount =
      tip_amount
      |> Float.ceil(2)

    total_amount =
      bill_amount + tip_amount
      |> Float.ceil(2)

    {:ok, %{tip: tip_amount, total: total_amount}}
  end

  def calculate(_, _), do: {:error, :invalid_input}

  @doc """
  Prompt for user input and calculate tip amount and total.
  """
  def run do
    bill_amount = get_amount("Enter bill amount:")
    tip_rate = get_amount("Enter tip percentage:")

    case calculate(bill_amount, tip_rate) do
      {:ok, %{tip: tip, total: total}} ->
        IO.puts "Tip: #{tip}"
        IO.puts "Total: #{total}"
      _ ->
        IO.puts "There was a problem calculating the amount."
    end
  end

  @doc """
  Prompt for an amount using IO.gets.
  Takes the prompt string as its single argument.
  """
  def get_amount(prompt) do
    input = IO.gets(prompt)
    Logger.debug "Input: #{input}"

    amount = parse_gets(input)

    case validate_amount(amount) do
      {:ok, amount} -> amount
      {:error, _} -> get_amount(prompt)
    end
  end

  @doc """
  Parse user input. Return a float if the input is valid.

    iex> parse_gets("1.1")
    1.1

    iex> parse_gets("not_number")
    :error
  """
  def parse_gets(input) do
    amount = input |> String.trim |> Float.parse

    case amount do
      {float, _} -> float
      :error -> :error
    end
  end

  @doc """
  Validate the parsed user input to verify it's a non-negative float.

    iex> validate_amount(1.1)
    {:ok, 1.1}

    iex> validate_amount(-1.1)
    {:error, :invalid_input}
  """
  def validate_amount(amount) do
    case amount do
      amount when is_float(amount) and amount >= 0.0 ->
        {:ok, amount}
      _ ->
        {:error, :invalid_input}
    end
  end
end
