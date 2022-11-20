defmodule Mimi.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :mimi,
      name: "Mimi",
      version: @version,
      elixir: "~> 1.14",
      description: description(),
      package: package(),
      docs: docs(),
      source_url: "https://github.com/epfahl/mimi",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Mimi provides Agent-based memoization for single-argument anonymous functions."
  end

  defp package() do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Eric Pfahl"],
      licenses: ["MIT"],
      links: %{
        GitHub: "https://github.com/epfahl/mimi"
      }
    ]
  end

  defp docs() do
    [
      main: "Mimi",
      extras: ["README.md"]
    ]
  end
end
