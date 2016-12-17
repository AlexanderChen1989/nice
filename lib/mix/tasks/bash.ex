defmodule Mix.Tasks.Gen.Bash do
  use Mix.Task


  def run(_) do
    IO.puts "\n\n"
    try do
      gen(Models.models, Models.connects)
    rescue
      _ -> help |> IO.puts
    end
    IO.puts "\n\n"
  end

  def gen(models, connects) do
    IO.puts "#!/bin/bash\n\n"

    models
      |> Enum.each(fn {model, table, fields} ->
          IO.puts "mix phoenix.gen.html #{model} #{table} #{fields |> Enum.join(" ")}"
        end)

    models
      |> Enum.each(fn {model, table, fields} ->
          IO.puts "mix phoenix.gen.json API.#{model} #{table} #{fields |> Enum.join(" ")} --no-model"
        end)

    IO.puts "\n\n"

    models
      |> Enum.each(fn {model, table, _} ->
          IO.puts "resource \"/#{table}\", #{model}Controller"
        end)

    IO.puts "\n"
    
    models
      |> Enum.each(fn {model, table, _} ->
          IO.puts "resource \"/#{table}\", API.#{model}Controller, except: [:new, :edit]"
        end)


    models =
      models
      |> Enum.map(fn {m, _, _} -> m end)

    IO.puts "\n\n#!/bin/bash\n\n"

    gets =
      connects
      |> Enum.map(fn {from, to} ->
          if (not from in models) || (not to in models) do
            raise "{#{from}, #{to}} should in #{models |> inspect}"
          end

          from_lower = from |> String.downcase
          to_lower = to |> String.downcase

          model = "#{from}To#{to}"
          table = "#{from_lower}_to_#{to_lower}s"
          fields = "#{from_lower}_id:integer #{to_lower}_id:integer"

          IO.puts "mix gen.connect #{model} #{table} #{fields}"

          [
            "get \"/connect/#{table}\" #{model}ConnectController, :connect",
            "get \"/connect/#{table}/toggle\" #{model}ConnectController, :toggle"
          ]
        end)

    IO.puts "\n\n"

    gets
    |> Enum.each(fn [c, t] ->
        IO.puts c
        IO.puts t
      end)

  end

  def help do
    ~S<
Please define models like this:

lib/models.ex

defmodule Models do
  import ModelTypes

  def models do
    [
      { "User", "users", [
          string("name"),
          integer("age"),
      ]},
      { "Profile", "profiles", [
          string("agender"),
          decimal("height"),
      ]}
    ]
  end

  def connects do
    [
      {"User", "Profile"}
    ]
  end
end
    >


  end


end
