defmodule Nice.CowController do
  use Nice.Web, :controller

  alias Nice.Cow



  def index(conn, params) do
    cows = Repo.all(Cow)
    render(conn, "index.html", cows: cows, params: params)
  end

  def new(conn, params) do
    changeset = Cow.changeset(%Cow{})
    render(conn, "new.html", changeset: changeset, params: params)
  end



  def create(conn, %{"cow" => cow_params}) do
    changeset = Cow.changeset(%Cow{}, cow_params)

    case Repo.insert(changeset) do
      {:ok, _cow} ->
        conn
        |> put_flash(:info, "Cow created successfully.")
        |> redirect(to: cow_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{})
    end
  end



  def show(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)
    render(conn, "show.html", cow: cow, params: %{})
  end



  def edit(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)
    changeset = Cow.changeset(cow)
    render(conn, "edit.html", cow: cow, changeset: changeset, params: %{})
  end




  def update(conn, %{"id" => id, "cow" => cow_params}) do
    cow = Repo.get!(Cow, id)
    changeset = Cow.changeset(cow, cow_params)

    case Repo.update(changeset) do
      {:ok, cow} ->
        conn
        |> put_flash(:info, "Cow updated successfully.")
        |> redirect(to: cow_path(conn, :show, cow))
      {:error, changeset} ->
        render(conn, "edit.html", cow: cow, changeset: changeset, params: %{})
    end
  end



  def delete(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cow)

    conn
    |> put_flash(:info, "Cow deleted successfully.")
    |> redirect(to: cow_path(conn, :index))
  end
end
