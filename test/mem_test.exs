defmodule MimiTest do
  use ExUnit.Case
  doctest Mimi

  test "fibonacci timing test" do
    fib = fn n ->
      {:ok, _, f_mem} =
        fn {f, n} ->
          if n <= 1 do
            n
          else
            f.({f, n - 2}) + f.({f, n - 1})
          end
        end
        |> Mimi.memoize()

      f_mem.({f_mem, n})
    end

    {time, result} = :timer.tc(fn -> fib.(50) end)

    # It's extremely unlikely this will run longer than 100 ms.
    assert time < 100_000
    assert result == 12_586_269_025
  end
end
