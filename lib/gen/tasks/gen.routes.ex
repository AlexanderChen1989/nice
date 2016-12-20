defmodule Mix.Tasks.Gen.Routes do
  use Mix.Task

  def run(_) do
    IO.puts "\n# HTML Routes"

    html_routes
    |> Enum.each(&IO.puts/1)

    IO.puts "\n# Connect Routes"

    connect_routes
    |> Enum.each(&IO.puts/1)

    # IO.puts "\n# API Routes"
    # api_routes
    # |> Enum.each(&IO.puts/1)

  end


  defp html_routes do
    Models.models
    |> Enum.map(fn {model, table, _} ->
        "resources \"/#{table}\", #{model}Controller"
      end)
  end

  defp api_routes do
    Models.models
    |> Enum.map(fn {model, table, _} ->
        "resources \"/#{table}\", API.#{model}Controller, except: [:new, :edit]"
      end)
  end

  defp connect_routes do
    Models.connect_models
    |> Enum.map(fn {model, table, _} ->
        "get \"/connect/#{table}\", #{model}ConnectController, :connect"
        <>
        "\nget \"/connect/#{table}/toggle\", #{model}ConnectController, :toggle"
      end)
  end

end
