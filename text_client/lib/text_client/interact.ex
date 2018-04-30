defmodule TextClient.Interact do
    @hangman_server :hangman@ripper

    alias TextClient.{Player, State}

    def start() do
        Hangman.new_game()
        |> setup_state()
        |> Player.play()
    end

    defp setup_state(game) do
        %State{
            game_service: game,
            tally:        Hangman.tally(game),
        }
    end

    def new_game() do
        Node.connect(@hangman_server)
        :rpc.call(@hangman_server, Hangman, :new_game, [])
    end
end
