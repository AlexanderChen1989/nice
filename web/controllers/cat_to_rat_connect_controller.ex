defmodule Nice.CatToRatConnectController do
  use Nice.Web, :controller

  require Logger

  alias Nice.CatToRat
  alias Nice.Cat
  alias Nice.Rat

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connection(from, to)
    end

    redirect conn, to: cat_to_rat_connect_path(conn, :connect, from: from)
  end

  def connect(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse

    cats =
      Repo.all(Cat)
      |> mark_item(&(&1.id == from))

    rat_ids =
      Repo.all(Nice.CatToRat)
      |> Enum.filter_map(& &1.cat_id == from, & &1.rat_id)

    rats =
      Repo.all(Rat)
      |> mark_item(& &1.id in rat_ids)

    render conn, "connect.html", cats: cats, rats: rats, from: from
  end



  defp toggle_connection(from, to) do
    query = from u in Nice.CatToRat,
      where: u.cat_id == ^from and u.rat_id == ^to,
      select: u

    case query |> Repo.all() do
      [] ->
        %Nice.CatToRat{cat_id: from, rat_id: to} |> Repo.insert
      ups ->
        ups |> Enum.each(&Repo.delete/1)
    end
  end

  defp mark_item(items, check) do
    List.foldr(items, [], fn item, acc ->
      if check.(item) do
        [%{item | marked: true} | acc]
      else
        [%{item | marked: false} | acc]
      end
    end)
  end
end
