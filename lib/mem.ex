defmodule Mimi do
  @moduledoc """
  A very simple memoization implementation that uses an Agent to store state.
  """

  alias Mimi.Store

  @doc """
  Memoize an anonymous function `fun` of a single argument. This returns
  `{:ok, pid, fun_mem}`, where `pid` is the PID of the `Agent` that stores
  the memoized state, and `fun_mem` is the memoized function.
  """
  def memoize(fun) do
    {:ok, pid} = Store.start_link()

    fun_mem = fn x ->
      Store.get_or_put(pid, x, fn -> fun.(x) end)
    end

    {:ok, pid, fun_mem}
  end
end
