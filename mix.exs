defmodule ConcurrentCalendar.MixProject do
  use Mix.Project

  def project do
    [
      app: :concurrent_calendar,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:table_rex, "~> 3.1.0"},
      {:timex, "~> 3.6"}
    ]
  end
end
