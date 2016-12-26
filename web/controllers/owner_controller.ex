defmodule Nice.OwnerController do
  use Nice.Web, :controller

  alias Nice.Owner

  def index(conn, _params) do
    owners = Repo.all(Owner)
    render(conn, "index.html", owners: owners)
  end

  def new(conn, _params) do
    changeset = Owner.changeset(%Owner{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"owner" => owner_params}) do
    changeset = Owner.changeset(%Owner{}, owner_params)

    case Repo.insert(changeset) do
      {:ok, _owner} ->
        conn
        |> put_flash(:info, "Owner created successfully.")
        |> redirect(to: owner_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    owner = Repo.get!(Owner, id)
    render(conn, "show.html", owner: owner)
  end

  def edit(conn, %{"id" => id}) do
    owner = Repo.get!(Owner, id)
    changeset = Owner.changeset(owner)
    render(conn, "edit.html", owner: owner, changeset: changeset)
  end

  def update(conn, %{"id" => id, "owner" => owner_params}) do
    owner = Repo.get!(Owner, id)
    changeset = Owner.changeset(owner, owner_params)

    case Repo.update(changeset) do
      {:ok, owner} ->
        conn
        |> put_flash(:info, "Owner updated successfully.")
        |> redirect(to: owner_path(conn, :show, owner))
      {:error, changeset} ->
        render(conn, "edit.html", owner: owner, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    owner = Repo.get!(Owner, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(owner)

    conn
    |> put_flash(:info, "Owner deleted successfully.")
    |> redirect(to: owner_path(conn, :index))
  end
end
