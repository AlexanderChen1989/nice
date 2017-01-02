defmodule Nice.PigToCowConnectController do
  use Nice.Web, :controller

  require Logger

  alias Nice.Pig
  alias Nice.Cow

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connect(from, to)
    end

    redirect conn, to: pig_to_cow_connect_path(conn, :connect, params)
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
      Repo.paginate(Pig, from_params)

    pigs =
      page_from.entries
      |> mark_item(&(&1.id == from))

    cow_ids =
      (from ft in Nice.PigToCow,
        where: ft.pig_id == ^from,
        select: ft.cow_id)
      |> Repo.all

    page_to =
      Repo.paginate(Cow, to_params)

    cows =
      page_to.entries
      |> mark_item(& &1.id in cow_ids)

    render(
      conn, "connect.html",
      page_from: page_from,
      page_to: page_to,
      pigs: pigs,
      cows: cows,
      from: from
    )
  end

  defp toggle_connect(from, to) do
    query = from u in Nice.PigToCow,
      where: u.pig_id == ^from and u.cow_id == ^to,
      select: u

    case query |> Repo.all() do
      [] ->
        %Nice.PigToCow{pig_id: from, cow_id: to} |> Repo.insert
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
