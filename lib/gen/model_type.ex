defmodule ModelDefinition do
  @type model :: {String.t, String.t, list(String.t)}
  @type connect :: {String.t, String.t}

  @callback models() :: list(model)
  @callback connects() :: list(connect)
end

defmodule ModelType do
  defmacro __using__(_) do
    quote do
      @behaviour ModelDefinition
      import ModelType

      def tos(from) do
        connects
        |> Enum.filter(fn {f, _} -> f == from end)
        |> Enum.map(fn {_, t} -> t end)
      end

      def froms(to) do
        connects
        |> Enum.filter(fn {_, t} -> t == to end)
        |> Enum.map(fn {f, _} -> f end)
      end

      def connect_models() do
        ms = Enum.map(models, fn {m, _, _} -> m end)

        connects
        |> Enum.map(fn {from, to} ->
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
