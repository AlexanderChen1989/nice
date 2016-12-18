defmodule Mix.Tasks.Gen.Run do
  use Mix.Task

  def run(_) do
    NewGen.bash
  end
end


defmodule NewGen do
  def bash do
    models = Models.models ++ Models.connect_models
    connect_models = Models.connect_models

    (models |> Enum.map(&html_bash/1))
    ++ (connect_models |> Enum.map(&connect_bash/1))
    ++ (models |> Enum.map(&api_bash/1))
  end

  defp api_bash({model, table, fields}) do
    {
      "phoenix.gen.json",
      ["API.#{model}", "#{table}"] ++ fields ++ ["--no-model"]
    }
  end

  defp html_bash({model, table, fields}) do
    {
      "phoenix.gen.html",
      ["#{model}", "#{table}"] ++ fields]
    }
  end

  defp connect_bash({model, table, fields}) do
    {
      "gen.connect",
      ["#{model}", "#{table}"] ++ fields
    }
  end
end
