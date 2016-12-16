defmodule Nice.GoodGroupController do
  use Nice.Web, :controller

  alias Nice.GoodGroup

  def index(conn, _params) do
    good_groups = Repo.all(GoodGroup)
    render(conn, "index.html", good_groups: good_groups)
  end

  def new(conn, _params) do
    changeset = GoodGroup.changeset(%GoodGroup{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"good_group" => good_group_params}) do
    changeset = GoodGroup.changeset(%GoodGroup{}, good_group_params)

    case Repo.insert(changeset) do
      {:ok, _good_group} ->
        conn
        |> put_flash(:info, "Good group created successfully.")
        |> redirect(to: good_group_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    good_group = Repo.get!(GoodGroup, id)
    render(conn, "show.html", good_group: good_group)
  end

  def edit(conn, %{"id" => id}) do
    good_group = Repo.get!(GoodGroup, id)
    changeset = GoodGroup.changeset(good_group)
    render(conn, "edit.html", good_group: good_group, changeset: changeset)
  end

  def update(conn, %{"id" => id, "good_group" => good_group_params}) do
    good_group = Repo.get!(GoodGroup, id)
    changeset = GoodGroup.changeset(good_group, good_group_params)

    case Repo.update(changeset) do
      {:ok, good_group} ->
        conn
        |> put_flash(:info, "Good group updated successfully.")
        |> redirect(to: good_group_path(conn, :show, good_group))
      {:error, changeset} ->
        render(conn, "edit.html", good_group: good_group, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    good_group = Repo.get!(GoodGroup, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(good_group)

    conn
    |> put_flash(:info, "Good group deleted successfully.")
    |> redirect(to: good_group_path(conn, :index))
  end
end
