defmodule <%= module %>ConnectController do
  use <%= base %>.Web, :controller

  require Logger

  alias <%= "#{base}.#{from}" %>
  alias <%= "#{base}.#{to}" %>

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connect(from, to)
    end

    redirect conn, to: <%= singular %>_connect_path(conn, :connect, params)
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
      Repo.paginate(<%= from %>, from_params)

    <%= from_plural %> =
      page_from.entries
      |> mark_item(&(&1.id == from))

    <%= to_singular %>_ids =
      (from ft in <%= module %>,
        where: ft.<%= from_singular %>_id == ^from,
        select: ft.<%= to_singular %>_id)
      |> Repo.all

    page_to =
      Repo.paginate(<%= to %>, to_params)

    <%= to_plural %> =
      page_to.entries
      |> mark_item(& &1.id in <%= to_singular %>_ids)

    render(
      conn, "connect.html",
      page_from: page_from,
      page_to: page_to,
      owners: <%= from_plural %>,
      cats: <%= to_plural %>,
      from: from
    )
  end

  defp toggle_connect(from, to) do
    query = from u in <%= module %>,
      where: u.<%= from_singular %>_id == ^from and u.<%= to_singular %>_id == ^to,
      select: u

    case query |> Repo.all() do
      [] ->
        %<%= module %>{<%= from_singular %>_id: from, <%= to_singular %>_id: to} |> Repo.insert
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
