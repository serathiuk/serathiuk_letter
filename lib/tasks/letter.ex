defmodule Mix.Tasks.Letter do
  use Mix.Task

  def run(_) do
    Letter.new_game_and_play()
  end
end
