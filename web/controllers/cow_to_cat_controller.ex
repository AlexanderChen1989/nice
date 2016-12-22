defmodule Nice.CowToCatController do
  use Nice.Web, :controller

  alias Ecto.Multi
  alias Nice.{Cat, Cow, CowToCat}

  def index(conn, %{"cow_id" => cow_id}) do
    cow = Repo.one(
      from c in Cow,
      where: c.id == ^cow_id,
      preload: :cats,
      select: c
    )
    render(conn, "index.html", cats: cow.cats, cow: cow)
  end

  def new(conn, %{"cow_id" => cow_id}) do
    cow = Repo.get(Cow, cow_id)
    changeset = Cat.changeset(%Cat{})
    render(conn, "new.html", changeset: changeset, cow: cow)
  end

  def get_cow(_, cow_id) do
    case Repo.get(Cow, cow_id) do
      nil -> {:error, "Cow not found"}
      cow -> {:ok, cow}
    end
  end

  defp create_cat(_, cat_params) do
    changeset = Cat.changeset(%Cat{}, cat_params)
    Repo.insert(changeset)
  end

  defp add_cow_to_cat(%{cow: cow, cat: cat}) do
    Repo.insert(%CowToCat{cow: cow, cat: cat})
  end

  def create(conn, %{"cat" => cat_params, "cow_id" => cow_id}) do
    result =
      Multi.new
      |> Multi.run(:cow, &get_cow(&1, cow_id))
      |> Multi.run(:cat, &create_cat(&1, cat_params))
      |> Multi.run(:cow_to_cat, &add_cow_to_cat(&1))
      |> Repo.transaction

    case result do
      {:ok, changes} ->
        conn
        |> put_flash(:info, "Cat created successfully.")
        |> redirect(to: cow_to_cat_path(conn, :index, changes.cow))
      {:error, :cow, _, _} ->
        conn
        |> put_flash(:error, "Can't create cow!")
        |> redirect(to: cat_path(conn, :index))
      {:error, operation, value, changes} when operation in [:cat, :cow_to_cat]->
        render(conn, "new.html", changeset: value, cow: changes.cow)
    end
  end

  def show(conn, %{"id" => id, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)
    cow = Repo.get!(Cat, id)
    render(conn, "show.html", cat: cat, cow: cow)
  end

  def edit(conn, %{"id" => id, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)
    cow = Repo.get!(Cow, id)
    changeset = Cat.changeset(cat)
    render(conn, "edit.html", cat: cat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cat" => cat_params, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)
    cow = Repo.get!(Cow, cow_id)
    changeset = Cat.changeset(cat, cat_params)

    case Repo.update(changeset) do
      {:ok, cat} ->
        conn
        |> put_flash(:info, "Cat updated successfully.")
        |> redirect(to: cow_to_cat_path(conn, :show, cow, cat))
      {:error, changeset} ->
        render(conn, "edit.html", cat: cat, cow: cow, changeset: changeset)
    end
  end

  def delete_cat(_, cat) do
    Repo.delete(cat)
  end

  def delete_cow_to_cat(_, cow_id, cat_id) do
    cc = Repo.get_by!(CowToCat, cow_id: cow_id, cat_id: cat_id)
    IO.inspect cc
    Repo.delete(cc)
  end

  def delete(conn, %{"id" => id, "cow_id" => cow_id}) do
    cow = Repo.get!(Cow, cow_id)
    cat = Repo.get!(Cat, id)

    Multi.new
    |> Multi.run(:cow_to_cat, &delete_cow_to_cat(&1, cow_id, id))
    |> Multi.run(:cat, &delete_cat(&1, cat))
    |> Repo.transaction

    conn
    |> put_flash(:info, "Cat deleted successfully.")
    |> redirect(to: cow_to_cat_path(conn, :index, cow))
  end
end
