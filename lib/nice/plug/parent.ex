defmodule Nice.Plug.Parent do
  use Plug.Builder
  alias Nice.{Repo, Pig, Cow, PigToCow}
  import Ecto.Query

  def call(%{params: %{"pig_id" => pig_id, "cow_id" => cow_id} = params} = conn, _) do
    query =
      from pig_to_cow in PigToCow,
        where: [pig_id: ^pig_id, cow_id: ^cow_id],
        preload: [:pig],
        select: pig_to_cow

    case Repo.one(query) do
      nil ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Page not found")
        |> halt

      %{pig: pig} ->
        %{conn| params: Map.put(params, "id", cow_id)}
        |> assign(:parent_type, "Pig")
        |> assign(:parent, pig)
    end
  end

  def call(%{params: %{"pig_id" => pig_id}} = conn, _) do
    case Repo.get(Pig, pig_id) do
      nil ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Page not found")
        |> halt

      pig ->
        conn
        |> assign(:parent_type, "Pig")
        |> assign(:parent, pig)
    end
  end


  def call(conn, _), do: conn
end
