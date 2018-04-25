defmodule Hangman.Application do
  use Application

  def start(_type, _args) do
    options = [
      name: Hangman.DynamicSupervisor,
      strategy: :one_for_one
    ]

    DynamicSupervisor.start_link(options)
  end
end
