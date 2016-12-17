defmodule Nice.API.CatToRatController do
  use Nice.Web, :controller

  alias Nice.CatToRat

  def index(conn, _params) do
    cat_to_rats = Repo.all(CatToRat)
    render(conn, "index.json", cat_to_rats: cat_to_rats)
  end

  def create(conn, %{"cat_to_rat" => cat_to_rat_params}) do
    changeset = CatToRat.changeset(%CatToRat{}, cat_to_rat_params)

    case Repo.insert(changeset) do
      {:ok, cat_to_rat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", cat_to_rat_path(conn, :show, cat_to_rat))
        |> render("show.json", cat_to_rat: cat_to_rat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cat_to_rat = Repo.get!(CatToRat, id)
    render(conn, "show.json", cat_to_rat: cat_to_rat)
  end

  def update(conn, %{"id" => id, "cat_to_rat" => cat_to_rat_params}) do
    cat_to_rat = Repo.get!(CatToRat, id)
    changeset = CatToRat.changeset(cat_to_rat, cat_to_rat_params)

    case Repo.update(changeset) do
      {:ok, cat_to_rat} ->
        render(conn, "show.json", cat_to_rat: cat_to_rat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cat_to_rat = Repo.get!(CatToRat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat_to_rat)

    send_resp(conn, :no_content, "")
  end
end
