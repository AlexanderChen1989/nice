
defmodule RelationDefinition do
  @type model :: {String.t, String.t, list(String.t)}
  @type relation :: {
    String.t,
    :has_one | :has_many | :many_to_many,
    String.t
  }

  @callback models() :: list(model)
  @callback relations() :: list(relation)
end

defmodule Relation do
  defmacro __using__(_) do
    quote do
      @behaviour RelationDefinition
      import Relation

      def tasks do
        model_tasks ++ many_to_many_tasks ++ relation_tasks
      end

      defp relation_tasks do
        Models.relations
        |> gen_many_to_many_models
        |> Enum.map(fn {model, table, fields} ->
            [
              "mix",
              "gen.connect"
            ] ++ ["#{model}", "#{table}"] ++ fields
          end)
      end

      def gen_many_to_many_models(relations) do
        relations
        |> Enum.filter(fn {_, rel, _} -> rel == :many_to_many end)
        |> Enum.map(&many_to_many_to_model/1)
      end

      def many_to_many_to_model({from, _, to}) do
        ms = Enum.map(models, fn {m, _, _} -> m end)
        if (not from in ms) || (not to in ms) do
         raise "#{from} or #{to} should in #{ms |> inspect}"
        end

        from_lower = Macro.underscore(from)
        to_lower = Macro.underscore(to)

        model = "#{from}To#{to}"
        table = "#{from_lower}_to_#{to_lower}s"
        fields = [
         "#{from_lower}_id:references:#{from_lower}s",
         "#{to_lower}_id:references:#{to_lower}s"
        ]

        {model, table, fields}
      end

      def many_to_many_tasks do
        relations
        |> Enum.filter(fn {_, to, _} -> to == :many_to_many end)
        |> Enum.map(fn {a, _, b} ->
          m = "#{a}To#{b}"
          t = Macro.underscore(m) <> "s"
          fa = Macro.underscore(a)
          fb = Macro.underscore(b)
          [
            "mix",
            "phoenix.gen.model",
            "#{m}",
            "#{t}",
            "#{fa}_id:references:#{fa}s",
            "#{fb}_id:references:#{fb}s",
          ]
          end)
      end

      def model_tasks do
        models
        |> sort_models(relations)
        |> Enum.map(fn {m, t, fs} ->
            rs = references(m, relations)
            ["mix", "phoenix.gen.html", "#{m}", "#{t}"] ++ fs ++ rs
          end)
      end

      def references(m, relations) do
        relations
        |> Enum.filter(fn {a, to, b} -> b == m end)
        |> Enum.map(&gen_reference/1)
      end

      def gen_reference({a, r, b}) do
        singular = Macro.underscore(a)
        case r do
          :has_one ->
            "#{singular}_id:references:#{singular}s"
          :has_many ->
            "#{singular}_id:references:#{singular}s"
          :many_to_many ->
            ""
        end
      end

      def sort_models(models, relations) do
        ordered =
          relations
          |> List.foldl({[], []}, fn({a, _, b}, {as, bs}) ->
                {[a| as], [b | bs]}
            end)
          |> case do
              {as, bs} ->
                (as |> Enum.reverse) ++ (bs |> Enum.reverse)
            end
          |> Enum.reduce([], fn i, acc ->
              if i in acc do
                acc
              else
                [i | acc]
              end
            end)
          |> Enum.reverse

        models
        |> Enum.reduce(ordered, fn {name, _, _}, acc ->
            unless name in acc do
              [name | acc]
            else
              acc
            end
          end)
        |> Enum.map(fn name ->
            models
            |> Enum.filter(fn {n, _, _} -> n == name end)
            |> case do
                [m] -> m
              end
          end)

      end
    end
  end

  def string(key) when is_binary(key), do: key <> ":string"
  def text(key) when is_binary(key), do: key <> ":text"
  def integer(key) when is_binary(key), do: key <> ":integer"
  def float(key) when is_binary(key), do: key <> ":float"
  def decimal(key) when is_binary(key), do: key <> ":decimal"
  def boolean(key) when is_binary(key), do: key <> ":boolean"
  def date(key) when is_binary(key), do: key <> ":date"
  def time(key) when is_binary(key), do: key <> ":time"
  # def datetime(key) when is_binary(key), do: key <> ":datetime"
  # def utc_datetime(key) when is_binary(key), do: key <> ":utc_datetime"
  # def naive_datetime(key) when is_binary(key), do: key <> ":naive_datetime"
  def uuid(key) when is_binary(key), do: key <> ":uuid"
end
