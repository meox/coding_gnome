defmodule Hangman do
  alias Hangman.GameServer

  defdelegate new_game(), to: GameServer
  defdelegate tally(game_pid), to: GameServer
  defdelegate make_move(game_pid, guess), to: GameServer
  defdelegate get_solution(game_pid), to: GameServer
end
