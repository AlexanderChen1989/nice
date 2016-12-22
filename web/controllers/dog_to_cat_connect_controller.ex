defmodule Nice.DogToCatConnectController do
  use Nice.Web, :controller

  require Logger

  alias Nice.Dog
  alias Nice.Cat

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connect(from, to)
    end

    redirect conn, to: dog_to_cat_connect_path(conn, :connect, from: from)
  end

  def connect(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse

    dogs =
      Repo.all(Dog)
      |> mark_item(&(&1.id == from))

    cat_ids =
      Repo.all(Nice.DogToCat)
      |> Enum.filter_map(& &1.dog_id == from, & &1.cat_id)

    cats =
      Repo.all(Cat)
      |> mark_item(& &1.id in cat_ids)

    render conn, "connect.html", dogs: dogs, cats: cats, from: from
  end

  defp toggle_connect(from, to) do
    query = from u in Nice.DogToCat,
      where: u.dog_id == ^from and u.cat_id == ^to,
      select: u

    case query |> Repo.all() do
      [] ->
        %Nice.DogToCat{dog_id: from, cat_id: to} |> Repo.insert
      ups ->
        ups |> Enum.each(&Repo.delete/1)
    end
  end

  defp mark_item(items, check) do
    List.foldr(items, [], fn item, acc ->
      if check.(item) do
        [Map.put(item, :marked, true) | acc]
      else
        [Map.put(item, :marked, false) | acc]
      end
    end)
  end
end
