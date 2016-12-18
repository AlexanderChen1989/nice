defmodule Mix.Tasks.Gen.Run do
  use Mix.Task

  def run(_) do
    tasks = html_tasks ++ connect_model_tasks ++ connect_tasks ++ api_tasks

    tasks
    |> Enum.each(&exec/1)
  end

  def exec({task, args}) do
    Mix.Task.clear()
    Mix.Task.run(task, args)

    Mix.shell.info(">>>>>>>>>>>>>>>>>>>>>>>>#{inspect task} #{inspect args}")

    if "--no-model" in args do
      sleep 100
    else
      sleep 2000
    end
  end

  def sleep(t), do: :timer.sleep(t)

  defp from_tos(model) do
      Models.connects
      |> Enum.filter_map(
          fn {from, _} -> from == model end,
          fn {from, to} -> "--connect #{from}:#{to}" end
        )
  end

  defp connect_model_tasks do
    Models.connect_models
    |> Enum.map(fn {model, table, fields} ->
        {
          "gen.model",
          ["#{model}", "#{table}"] ++ fields ++ from_tos(model)
        }
      end)
  end

  defp api_tasks do
    models = Models.models ++ Models.connect_models

    models
    |> Enum.map(fn {model, table, fields} ->
        {
          "phoenix.gen.json",
          ["API.#{model}", "#{table}"] ++ fields ++ ["--no-model"]
        }
      end)
  end

  defp html_tasks do
    Models.models
    |> Enum.map(fn {model, table, fields} ->
        {
          "phoenix.gen.html",
          ["#{model}", "#{table}"] ++ fields
        }
      end)
  end

  defp connect_tasks do
    Models.connect_models
    |> Enum.map(fn {model, table, fields} ->
        {
          "gen.connect",
          ["#{model}", "#{table}"] ++ fields
        }
      end)
  end

end
