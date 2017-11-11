defmodule GameTest do
  use ExUnit.Case
  doctest Hangman
  
  alias Hangman.Game
  
  test "should new_game should return the game state" do
    game = Game.new_game
    
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end
  
  test "it should not change game state when its already won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game |> Map.put(:game_state, :won)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end
  
  test "it should not have the status of :already_used for the first guess" do
    game = Game.new_game
    {game, _} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end
  
  test "it should have the status of :already_used for a guess that has already been used" do
    game = Game.new_game
    {game, _} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    
    {game, _} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end
  
  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end
  
  test "the whole word is recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    
    {game, _tally} = Game.make_move(game, "i")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    
    {game, _tally} = Game.make_move(game, "b")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    
    {game, _tally} = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
    
    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :won
    assert game.turns_left == 7
  end
  
  test "a bad guess is recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end
  
  test "the whole word is not recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
    
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state == :bad_guess
    assert game.turns_left == 5
    
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    assert game.turns_left == 4
    
    {game, _tally} = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 3
    
    {game, _tally} = Game.make_move(game, "p")
    assert game.game_state == :bad_guess
    assert game.turns_left == 2
    
    {game, _tally} = Game.make_move(game, "q")
    assert game.game_state == :bad_guess
    assert game.turns_left == 1
    
    {game, _tally} = Game.make_move(game, "r")
    assert game.game_state == :lost
    assert game.turns_left == 0
    
  end
  
end
