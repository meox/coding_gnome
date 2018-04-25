defmodule Hangman.Application do
  use Application

  def start(_type, _args) do
    children = [
      Hangman.Server
    ]

    options = [
      name: Hangmans.Supervisor,
      strategy: :simple_one_for_one,
      max_restarts: 3,
      max_seconds: 5
    ]

    Supervisor.start_link(children, options)
  end
end
