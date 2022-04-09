defmodule Letter do
  defstruct [:board, attemps: 0, success: false]

  @max_attemps 6

  @word_list ["BARCO", "BRITA", "BRUMA", "CHUVA", "CRIME", "CUSPE", "EDUCA", "FAUNA",
              "FRUTA", "GASTO", "GRUTA", "LINDO", "LINHO", "MESMO", "NERVO", "POUCA",
              "ORGAO", "PORTA", "POUCA", "RALAR", "RESTO", "SARRO", "TRUTA", "UNICO"]

  def new_game() do
    new_game("TRUTA")
  end

  def new_game(board_word) when is_bitstring(board_word) do
    new_game(Board.new(board_word))
  end

  def new_game(%Board{} = board) do
    %__MODULE__ {board: board}
  end

  def play(%Letter{} = letter) do
    letter
    |> execute_next_step()
  end

  def new_game_and_play() do
    new_game()
    |> play()
  end

  defp execute_next_step(%__MODULE__{success: true, board: %Board{word: correct_word}}) do
    IO.puts("-----------------------------------")
    IO.puts("Congratulations :)")
    IO.puts("The correct word is #{correct_word}.")
    IO.puts("-----------------------------------")
  end

  defp execute_next_step(%__MODULE__{attemps: @max_attemps, board: %Board{word: correct_word}}) do
    IO.puts("-----------------------------------")
    IO.puts("Game over :(")
    IO.puts("The correct word is #{correct_word}.")
    IO.puts("-----------------------------------")
  end

  defp execute_next_step(%Letter{} = letter) do
    player_word = read_player_valid_word(letter)
    player_guess = Board.guess(letter.board, player_word)
    attempts = letter.attemps + 1

    if correct_word?(player_guess) do
      execute_next_step(%__MODULE__{board: player_guess, attemps: attempts, success: true})
    else
      IO.puts("Incorrect. Partial result: #{player_guess.current_pattern}.")
      execute_next_step(%__MODULE__{board: player_guess, attemps: attempts, success: false})
    end
  end

  defp correct_word?(%Board{word: word, latest_guess: word}), do: true
  defp correct_word?(_), do: false

  defp read_player_valid_word(%Letter{} = letter) do
    word = read_player_word(letter)

    if valid_word?(word) do
      word
    else
      IO.puts("Invalid word. Try again.")
      read_player_valid_word(letter)
    end
  end

  defp read_player_word(%Letter{} = letter) do
    IO.gets("#{letter.attemps + 1}ª attempt: ")
    |> normalize_word()
  end

  defp normalize_word( word) do
    word
    |> String.trim()
    |> String.upcase()
    |> String.normalize(:nfd)
    |> String.replace(~r/[^A-z\s]/u, "")
  end

  defp valid_word?(word) when is_bitstring(word) do
    word in @word_list
  end

end
