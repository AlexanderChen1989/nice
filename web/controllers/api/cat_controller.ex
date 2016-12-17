defmodule Nice.API.CatController do
  use Nice.Web, :controller

  alias Nice.Cat

  def index(conn, _params) do
    cats = Repo.all(Cat)
    render(conn, "index.json", cats: cats)
  end

  def create(conn, %{"cat" => cat_params}) do
    changeset = Cat.changeset(%Cat{}, cat_params)

    case Repo.insert(changeset) do
      {:ok, cat} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", cat_path(conn, :show, cat))
        |> render("show.json", cat: cat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cat = Repo.get!(Cat, id)
    render(conn, "show.json", cat: cat)
  end

  def update(conn, %{"id" => id, "cat" => cat_params}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat, cat_params)

    case Repo.update(changeset) do
      {:ok, cat} ->
        render(conn, "show.json", cat: cat)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cat = Repo.get!(Cat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat)

    send_resp(conn, :no_content, "")
  end
end
