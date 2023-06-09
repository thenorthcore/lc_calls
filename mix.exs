defmodule CallsignFilter.MixProject do
  use Mix.Project

  def project do
    [
      app: :callsign_filter,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.7"}
    ]
  end
end
