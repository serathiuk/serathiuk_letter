defmodule LetterTest do
  use ExUnit.Case

  test "Testa a criação do jogo com um Jogo definido" do
    board = Board.new("PORTA")
    assert Letter.new_game("PORTA").board == board
  end

  test "Testa a criação do jogo com uma palavra pré-definida" do
    assert Letter.new_game("PORTA").board.word == "PORTA"
  end

end
