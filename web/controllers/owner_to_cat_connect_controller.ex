defmodule Nice.OwnerToCatConnectController do
  use Nice.Web, :controller

  require Logger

  alias Nice.Owner
  alias Nice.Cat

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connect(from, to)
    end

    redirect conn, to: owner_to_cat_connect_path(conn, :connect, params)
  end

  def connect(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse

    {from_params, to_params} =
      case params do
        %{"page_from" => from_page, "page" => to_page} ->
          {%{"page": from_page}, %{"page": to_page}}
        %{"page_to" => to_page, "page" => from_page} ->
          {%{"page": from_page}, %{"page": to_page}}
        _ ->
          {%{"page": 1}, %{"page": 1}}
      end

    page_from =
      Repo.paginate(Owner, from_params)

    owners =
      page_from.entries
      |> mark_item(&(&1.id == from))

    cat_ids =
      (from ft in Nice.OwnerToCat,
        where: ft.owner_id == ^from,
        select: ft.cat_id)
      |> Repo.all

    page_to =
      Repo.paginate(Cat, to_params)

    cats =
      page_to.entries
      |> mark_item(& &1.id in cat_ids)

    render(
      conn, "connect.html",
      page_from: page_from,
      page_to: page_to,
      owners: owners,
      cats: cats,
      from: from
    )
  end

  defp toggle_connect(from, to) do
    query = from u in Nice.OwnerToCat,
      where: u.owner_id == ^from and u.cat_id == ^to,
      select: u

    case query |> Repo.all() do
      [] ->
        %Nice.OwnerToCat{owner_id: from, cat_id: to} |> Repo.insert
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
