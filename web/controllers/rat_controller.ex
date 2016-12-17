defmodule Nice.RatController do
  use Nice.Web, :controller

  alias Nice.Rat

  def index(conn, _params) do
    rats = Repo.all(Rat)
    render(conn, "index.html", rats: rats)
  end

  def new(conn, _params) do
    changeset = Rat.changeset(%Rat{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"rat" => rat_params}) do
    changeset = Rat.changeset(%Rat{}, rat_params)

    case Repo.insert(changeset) do
      {:ok, _rat} ->
        conn
        |> put_flash(:info, "Rat created successfully.")
        |> redirect(to: rat_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rat = Repo.get!(Rat, id)
    render(conn, "show.html", rat: rat)
  end

  def edit(conn, %{"id" => id}) do
    rat = Repo.get!(Rat, id)
    changeset = Rat.changeset(rat)
    render(conn, "edit.html", rat: rat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "rat" => rat_params}) do
    rat = Repo.get!(Rat, id)
    changeset = Rat.changeset(rat, rat_params)

    case Repo.update(changeset) do
      {:ok, rat} ->
        conn
        |> put_flash(:info, "Rat updated successfully.")
        |> redirect(to: rat_path(conn, :show, rat))
      {:error, changeset} ->
        render(conn, "edit.html", rat: rat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rat = Repo.get!(Rat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(rat)

    conn
    |> put_flash(:info, "Rat deleted successfully.")
    |> redirect(to: rat_path(conn, :index))
  end
end
