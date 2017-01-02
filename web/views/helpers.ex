defmodule Nice.Helpers do
  def get(_, []), do: nil
  def get(map, [h | t]) do

    IO.inspect Map.get(map, h, nil)

    case Map.get(map, h, nil) do
      nil -> nil
      %{} = map -> map
      _ -> nil
    end
  end
end
