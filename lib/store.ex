defmodule Mimi.Store do
  @moduledoc """
  An `Agent` backend for memoization.
  """

  use Agent

  @doc """
  Start the Agent process and initialize with an empty map.
  """
  def start_link(), do: Agent.start_link(fn -> %{} end)

  @doc """
  Get a value associated with the given `key` or add and return the result of
  `fun.()` if the key isn't present.
  """
  def get_or_put(pid, key, fun) do
    case Agent.get(pid, &Map.fetch(&1, key)) do
      {:ok, value} ->
        value

      :error ->
        value = fun.()
        Agent.update(pid, &Map.put(&1, key, value))
        value
    end
  end
end
