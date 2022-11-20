[![Hex.pm Version](https://img.shields.io/hexpm/v/timex.svg?style=flat)](https://hex.pm/packages/mimi)

_`Mimi` the mini memoizer._

Sometimes you want a simple way to store and retrieve past function values. `Mimi` can 
help!

## Explanation and usage

[Memoization](https://en.wikipedia.org/wiki/Memoization) is a technique for
boosting performance of long-running 
[idempotent](https://en.wikipedia.org/wiki/Idempotence) functions. When a function is first called,
the function is executed with the given arguments and the result is stored. When the 
same function is called again with the same arguments, the result is retrieved directly
without executing the function.

`Mimi` has one function, `mmemoize`, that accepts an anonymous function with a single
argument and returns a tuple that contains the memoized version of that function. As an 
example, memoize the long-running function

```elixir
{:ok, pid, greet} = 
  fn name ->
    :timer.sleep(3_000)
    "Hello, #{name}!"
  end
  |> Mimi.memoize()
```

When `greet.("world")` is called the first time, it will run for about 3 seconds before 
returning `"Hello, world!"`.  When called a second time with the same argument, `greet` 
will return almost immediately with the same result.

## Under the hood

`Mimi` uses an `Agent` to store a map from argument values to the returned result. 
`Mimi.memoize` is a function that starts the `Agent` process and returns a three-element
tuple `{:ok, pid, memoized_function}`. The PID of the `Agent` is made available
so that the process can be inspected or terminated with `Agent.get` or `Agent.stop`, 
respectively.

## Notes

### Disclaimer

The memoized state in `Mimi` is managed in anyway; it will continue to grow until the
parent process is terminated or until the `Agent` process is terminated manually. 
It is not advisable to use `Mimi` is critical applications.

### Recursion

`Mimi` will happily memoize a recursive function, but only at the top level. It will not
memoize the internal recursive calls. So, if you're trying to speed up a naively 
recursive Fibonacci generator, `Mimi` won't be of much help. It's certainly possible to 
write the function in a way that uses memoization, but it wouldn't be a simple wrapper. 
A memoized version of a naive recursive implementation of a generator for Fibonacci 
numbers might look like

```elixir
fib = fn n ->
  {:ok, _, f_mem} = fn {f, n} ->
    if n <= 1 do
      n
    else
      f.({f, n - 2}) + f.({f, n - 1})
    end
  end
  |> Mimi.memoize()

  f_mem.({f_mem, n})
end
```

Without memoization, this function has exponentially time complexity. Good
luck waiting around for the 100th Fibonacci number! With memoization, this function function
returns in milliseconds. You'll see that `fib.(100)` yields 354224848179261915075.