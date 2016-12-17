defmodule <%= module %>ConnectController do
  use <%= base %>.Web, :controller

  require Logger

  alias <%= module %>
  alias <%= "#{base}.#{from}" %>
  alias <%= "#{base}.#{to}" %>

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connection(from, to)
    end

    redirect conn, to: <%= singular %>_connect_path(conn, :connect, from: from)
  end

  def connect(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse

    <%= from_plural %> =
      Repo.all(<%= from %>)
      |> mark_item(&(&1.id == from))

    <%= to_singular %>_ids =
      Repo.all(<%= module %>)
      |> Enum.filter_map(& &1.<%= from_singular %>_id == from, & &1.<%= to_singular %>_id)

    <%= to_plural %> =
      Repo.all(<%= to %>)
      |> mark_item(& &1.id in <%= to_singular %>_ids)

    render conn, "connect.html", <%= from_plural %>: <%= from_plural %>, <%= to_plural %>: <%= to_plural %>, from: from
  end

  defp toggle_connection(from, to) do
    case <%= module %>.find(from, to) |> Repo.all() do
      [] ->
        %<%= module %>{<%= from_singular %>_id: from, <%= to_singular %>_id: to} |> Repo.insert
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
