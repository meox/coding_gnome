defmodule Hangman.GameServer do
  def new_game() do
    {:ok, pid} = DynamicSupervisor.start_child(Hangman.DynamicSupervisor, Hangman.Server)
    pid
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end
  
  def get_solution(game_pid) do
    GenServer.call(game_pid, {:solution})
  end
end
