defmodule TextClient.Player do
    
    alias TextClient.{Prompter, Mover, State, Summary}

    # :won, :lost, :good_guess, :bad_guess, :initializing, :already_used
    def play(%State{ tally: %{ game_state: :won} }) do
        IO.ANSI.format(["You ", :green, :bright, "WON!"])
        |> exit_with_message()
    end

    def play(%State{ game_service: game_pid, tally: %{ game_state: :lost} }) do
        IO.ANSI.format([
            "Sorry, you ", :red, :bright, "LOST! ", :reset,
            "(the word was: ", :yellow, :bright, "#{get_solution(game_pid)})"
        ])
        |> exit_with_message()
    end

    def play(game = %State{ tally: %{ game_state: :good_guess} }) do
        msg = IO.ANSI.format([:bright, :white, "\nYep! ", :green, :bright, "Good Guess"])
        continue_with_message(game, msg)
    end

    def play(game = %State{ tally: %{ game_state: :bad_guess} }) do
        msg = IO.ANSI.format([:bright, :red, "\nSorry, that isn't in the word"])
        continue_with_message(game, msg)
    end

    def play(game = %State{ tally: %{ game_state: :already_used} }) do
        continue_with_message(game, "You have already used that letter")
    end

    def play(game = %State{ tally: %{ game_state: :initializing} }) do
        continue_with_message(game, "Have fun!")
    end

    def continue(game) do
        game
        |> Summary.display()
        |> Prompter.accept_move()
        |> Mover.make_move()
        |> play()
    end

    ########################################

    defp continue_with_message(game, msg) do
        IO.puts(msg)
        continue(game)
    end

    defp exit_with_message(msg) do
        IO.puts(msg)
        exit(:normal)
    end

    defp get_solution(game_pid) do
        Hangman.get_solution(game_pid)
    end
end
