defmodule Gen do
  def bash do
    models = Models.models ++ Models.connect_models
    connect_models = Models.connect_models

    IO.puts("#!/bin/bash")

    IO.puts "\n# Gen Models"

    models
    |> gen_bash(&html_bash/1)
    |> Enum.map(&IO.puts/1)

    IO.puts "\n# Gen Connects"

    connect_models
    |> gen_bash(&connect_bash/1)
    |> Enum.map(&IO.puts/1)

    IO.puts "\n# Gen APIs"

    models
    |> gen_bash(&api_bash/1)
    |> Enum.map(&IO.puts/1)
  end

  def routes do
    models = Models.models ++ Models.connect_models
    connect_models = Models.connect_models

    IO.puts "\n# HTML Routes"
    models
    |> gen_routes(&html_route/1)
    |> Enum.map(&IO.puts/1)

    IO.puts "\n# Connect Routes"
    connect_models
    |> gen_routes(&connect_route/1)
    |> Enum.map(&IO.puts/1)

    IO.puts "\n# API Routes"
    models
    |> gen_routes(&api_route/1)
    |> Enum.map(&IO.puts/1)

  end

  defp api_bash({model, table, fields}) do
    "mix phoenix.gen.json API.#{model} #{table} #{fields |> Enum.join(" ")} --no-model"
  end

  defp html_bash({model, table, fields}) do
    "mix phoenix.gen.html #{model} #{table} #{fields |> Enum.join(" ")}"
    <>
    "\nsleep 2"
  end

  defp connect_bash({model, table, fields}) do
    "mix gen.connect #{model} #{table} #{fields |> Enum.join(" ")}"
  end

  defp html_route({model, table, _}) do
    "resources \"/#{table}\", #{model}Controller"
  end

  defp api_route({model, table, _}) do
    "resources \"/#{table}\", API.#{model}Controller, except: [:new, :edit]"
  end

  defp connect_route({model, table, _}) do
    "get \"/connect/#{table}\", #{model}ConnectController, :connect"
    <>
    "\nget \"/connect/#{table}/toggle\", #{model}ConnectController, :toggle"
  end

  defp gen_bash(models, bash) do
    agent = new_agent()

    models
    |> Enum.each(fn model ->
        agent
        |> put(bash.(model))
      end)

    get(agent)
  end

  defp gen_routes(models, route) do
    agent = new_agent()

    models
    |> Enum.each(fn model ->
        agent
        |> put(route.(model))
      end)

    get(agent)
  end

  defp new_agent() do
    {:ok, agent} = Agent.start_link fn -> [] end
    agent
  end

  defp put(agent, item) do
    Agent.update(agent, & [item | &1])
    agent
  end

  defp get(agent) do
    Agent.get(agent, & &1)
    |> Enum.reverse
  end
end
