defmodule Nice.PigController do
  use Nice.Web, :controller

  alias Nice.Pig



  def index(conn, params) do
    pigs = Repo.all(Pig)
    render(conn, "index.html", pigs: pigs, params: params)
  end

  def new(conn, params) do
    changeset = Pig.changeset(%Pig{})
    render(conn, "new.html", changeset: changeset, params: params)
  end



  def create(conn, %{"pig" => pig_params}) do
    changeset = Pig.changeset(%Pig{}, pig_params)

    case Repo.insert(changeset) do
      {:ok, _pig} ->
        conn
        |> put_flash(:info, "Pig created successfully.")
        |> redirect(to: pig_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{})
    end
  end



  def show(conn, %{"id" => id}) do
    pig = Repo.get!(Pig, id)
    render(conn, "show.html", pig: pig, params: %{})
  end



  def edit(conn, %{"id" => id}) do
    pig = Repo.get!(Pig, id)
    changeset = Pig.changeset(pig)
    render(conn, "edit.html", pig: pig, changeset: changeset, params: %{})
  end




  def update(conn, %{"id" => id, "pig" => pig_params}) do
    pig = Repo.get!(Pig, id)
    changeset = Pig.changeset(pig, pig_params)

    case Repo.update(changeset) do
      {:ok, pig} ->
        conn
        |> put_flash(:info, "Pig updated successfully.")
        |> redirect(to: pig_path(conn, :show, pig))
      {:error, changeset} ->
        render(conn, "edit.html", pig: pig, changeset: changeset, params: %{})
    end
  end



  def delete(conn, %{"id" => id}) do
    pig = Repo.get!(Pig, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pig)

    conn
    |> put_flash(:info, "Pig deleted successfully.")
    |> redirect(to: pig_path(conn, :index))
  end
end
