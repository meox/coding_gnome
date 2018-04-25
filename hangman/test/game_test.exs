defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "lowercase" do
    game = Game.new_game()

    r =
      game.letters
      |> Enum.map(fn x -> x =~ ~r/^\p{Ll}$/u end)
      |> Enum.reduce(fn x, y -> x && y end)

    assert r == true
  end

  test "state isn't changed from :won or :lost game" do
    for state <- [:won, :lost] do
      game =
        Game.new_game()
        |> Map.put(:game_state, state)

      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occorrence of letter is not already used" do
    {game, _} =
      Game.new_game()
      |> Game.make_move("x")

    assert game.game_state != :already_used
  end

  test "repeated move" do
    game = Game.new_game()
    {game, _} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "good guess" do
    game = Game.new_game("wibble")
    {ngame, _} = Game.make_move(game, "w")
    assert ngame.game_state == :good_guess
    assert ngame.turns_left == game.turns_left
  end

  test "won guess" do
    game = Game.new_game("wibble")

    final =
      MapSet.new(game.letters)
      |> Enum.reduce(game, fn guess, acc ->
        {game, _} = Game.make_move(acc, guess)
        game
      end)

    assert final.game_state == :won
    assert final.turns_left == 7
  end

  test "bad guess" do
    game = Game.new_game("wibble")
    {ngame, _} = Game.make_move(game, "z")
    assert ngame.game_state == :bad_guess
    assert ngame.turns_left == game.turns_left - 1
  end

  test "lost guess" do
    game = Game.new_game("wibble")

    final =
      MapSet.new(["x", "z", "k", "m", "v", "p", "o"])
      |> Enum.reduce(game, fn guess, acc ->
        {game, _} = Game.make_move(acc, guess)
        game
      end)

    assert final.game_state == :lost
    assert final.turns_left == 1
  end
end
