defmodule Mix.Tasks.Gen.Tasks.Connect do
  use Mix.Task

  def run(_) do
    IO.puts "OK"
  end
end


defmodule Mix.Tasks.Gen.Tasks.Routes do
  use Mix.Task

  def run(_) do
    Models.models
    |> Enum.map(fn {model, table, _} ->
        IO.puts "resources \"/#{table}\", #{model}Controller"
      end)
  end
end

defmodule Mix.Tasks.Gen.Tasks.Run do
  use Mix.Task

  def run(_) do
    Models.tasks
    |> Enum.map(&remove_empty/1)
    |> Enum.map(fn [_, task | args] -> {task, args} end)
    |> Enum.map(&puts_tasks/1)
    # |> Enum.map(&exec/1)
  end

  def puts_tasks({task, args}) do
    IO.puts "#{task} #{args |> Enum.join(" ")}"
    {task, args}
  end

  def remove_empty(lst) do
    lst
    |> Enum.filter(& String.trim(&1) != "")
  end

  def exec({task, args}) do
    Mix.shell.info(">>>>>>>>>>>>>>>>>>>>>>>>#{task} #{args |> Enum.join(" ")}")

    Mix.Task.clear()
    Mix.Task.run(task, args)

    if "--no-model" in args do
      :timer.sleep 100
    else
      :timer.sleep 1000
    end
  end
end
