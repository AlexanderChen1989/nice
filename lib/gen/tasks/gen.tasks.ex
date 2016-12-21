defmodule Mix.Tasks.Gen.Tasks do
  use Mix.Task

  def run(_) do
    Models.tasks
    |> Enum.map(&IO.inspect/1)
  end
end
