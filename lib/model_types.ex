defmodule ModelTypes do
  def string(key) when is_binary(key), do: key <> ":string"
  def text(key) when is_binary(key), do: key <> ":text"
  def integer(key) when is_binary(key), do: key <> ":integer"
  def float(key) when is_binary(key), do: key <> ":float"
  def decimal(key) when is_binary(key), do: key <> ":decimal"
  def boolean(key) when is_binary(key), do: key <> ":boolean"
  def date(key) when is_binary(key), do: key <> ":date"
  def time(key) when is_binary(key), do: key <> ":time"
  def datetime(key) when is_binary(key), do: key <> ":datetime"
  def uuid(key) when is_binary(key), do: key <> ":uuid"
end
