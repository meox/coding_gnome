defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game(world) do
    %Hangman.Game{
      letters: world |> String.codepoints()
    }
  end

  def new_game() do
    new_game(Dictionary.random_word())
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: reveal(game.letters, game.used),
      used: game.used |> Enum.to_list()
    }
  end

  def solution(game) do
    game.letters |> Enum.join("")
  end

  ######

  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _not_already_guessed) do
    accept_move_valid_guess(game, guess, is_valid_guess(guess))
  end

  defp accept_move_valid_guess(game, guess, _is_valid = true) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp accept_move_valid_guess(game, _guess, _is_not_valid) do
    Map.put(game, :game_state, :invalid_guess)
  end

  defp is_valid_guess(guess) do
    guess =~ ~r/\A[a-z]/
  end

  defp score_guess(game, _good_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won()

    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game = %{turns_left: 1}, _no_good_guess) do
    Map.put(game, :game_state, :lost)
  end

  defp score_guess(game = %{turns_left: left}, _no_good_guess) do
    %{game | game_state: :bad_guess, turns_left: left - 1}
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp reveal(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _is_in_world = true), do: letter
  defp reveal_letter(_letter, _is_not_in_world), do: "_"

  defp return_with_tally(game) do
    {game, tally(game)}
  end
end
