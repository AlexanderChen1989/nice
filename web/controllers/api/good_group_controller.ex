defmodule Nice.API.GoodGroupController do
  use Nice.Web, :controller

  alias Nice.GoodGroup

  def index(conn, _params) do
    good_groups = Repo.all(GoodGroup)
    render(conn, "index.json", good_groups: good_groups)
  end

  def create(conn, %{"good_group" => good_group_params}) do
    changeset = GoodGroup.changeset(%GoodGroup{}, good_group_params)

    case Repo.insert(changeset) do
      {:ok, good_group} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", good_group_path(conn, :show, good_group))
        |> render("show.json", good_group: good_group)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    good_group = Repo.get!(GoodGroup, id)
    render(conn, "show.json", good_group: good_group)
  end

  def update(conn, %{"id" => id, "good_group" => good_group_params}) do
    good_group = Repo.get!(GoodGroup, id)
    changeset = GoodGroup.changeset(good_group, good_group_params)

    case Repo.update(changeset) do
      {:ok, good_group} ->
        render(conn, "show.json", good_group: good_group)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    good_group = Repo.get!(GoodGroup, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(good_group)

    send_resp(conn, :no_content, "")
  end
end
