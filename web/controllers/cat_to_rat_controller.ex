defmodule Nice.CatToRatController do
  use Nice.Web, :controller

  alias Nice.CatToRat

  def index(conn, _params) do
    cat_to_rats = Repo.all(CatToRat)
    render(conn, "index.html", cat_to_rats: cat_to_rats)
  end

  def new(conn, _params) do
    changeset = CatToRat.changeset(%CatToRat{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cat_to_rat" => cat_to_rat_params}) do
    changeset = CatToRat.changeset(%CatToRat{}, cat_to_rat_params)

    case Repo.insert(changeset) do
      {:ok, _cat_to_rat} ->
        conn
        |> put_flash(:info, "Cat to rat created successfully.")
        |> redirect(to: cat_to_rat_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cat_to_rat = Repo.get!(CatToRat, id)
    render(conn, "show.html", cat_to_rat: cat_to_rat)
  end

  def edit(conn, %{"id" => id}) do
    cat_to_rat = Repo.get!(CatToRat, id)
    changeset = CatToRat.changeset(cat_to_rat)
    render(conn, "edit.html", cat_to_rat: cat_to_rat, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cat_to_rat" => cat_to_rat_params}) do
    cat_to_rat = Repo.get!(CatToRat, id)
    changeset = CatToRat.changeset(cat_to_rat, cat_to_rat_params)

    case Repo.update(changeset) do
      {:ok, cat_to_rat} ->
        conn
        |> put_flash(:info, "Cat to rat updated successfully.")
        |> redirect(to: cat_to_rat_path(conn, :show, cat_to_rat))
      {:error, changeset} ->
        render(conn, "edit.html", cat_to_rat: cat_to_rat, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cat_to_rat = Repo.get!(CatToRat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat_to_rat)

    conn
    |> put_flash(:info, "Cat to rat deleted successfully.")
    |> redirect(to: cat_to_rat_path(conn, :index))
  end
end
