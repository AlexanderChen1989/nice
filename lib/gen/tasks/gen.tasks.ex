defmodule Mix.Tasks.Gen.Tasks do
  use Mix.Task

  def run(_) do
    Models.tasks
    |> Enum.map([_, task | args])
    |> Enum.map(&exec/1)
  end

  def exec({task, args}) do
    Mix.shell.info(">>>>>>>>>>>>>>>>>>>>>>>>#{task} #{args |> List.join(" ")}")

    Mix.Task.clear()
    Mix.Task.run(task, args)

    if "--no-model" in args do
      sleep 100
    else
      sleep 2000
    end
  end
end
