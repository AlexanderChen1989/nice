defmodule Nice.CowController do
  use Nice.Web, :controller

  alias Nice.Cow
  alias Ecto.Multi

  def redirect_to(conn, method, cow \\ nil) do
    case {conn, method} do
      {%{assigns: %{parent: parent}}, :index} -> cow_path(conn, :index, parent, [])
      {conn, :index} -> cow_path(conn, :index)
      {%{assigns: %{parent: parent}}, :show} -> cow_path(conn, :show, parent, cow, [])
      {conn, :show} -> cow_path(conn, :show, cow)
    end
    |> (& redirect(conn, to: &1)).()
  end

  def index(%{assigns: %{parent_assoc: assoc}} = conn, params) do
    page = Repo.paginate(assoc, params)
    render(conn, "index.html", page: page, cows: page.entries)
  end

  def index(conn, params) do
    page = Repo.paginate(Cow, params)
    render(conn, "index.html", page: page, cows: page.entries)
  end

  def new(conn, _params) do
    changeset = Cow.changeset(%Cow{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{parent_relation: relation}} = conn, %{"cow" => cow_params}) do
    changeset = Cow.changeset(%Cow{}, cow_params)

    Multi.new
    |> Multi.insert(:cow, changeset)
    |> Multi.run(:relation, fn %{cow: cow} ->
        Repo.insert(%{relation | cow: cow})
      end)
    |> Repo.transaction
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Cow created successfully.")
        |> redirect_to(:index)
      {:error, :cow, changeset, _} ->
        render(conn, "new.html", changeset: changeset)
      _ ->
        conn
        |> put_flash(:error, "Cow creation failed.")
        |> render("new.html", changeset: changeset)
    end
  end

  def create(conn, %{"cow" => cow_params}) do
    changeset = Cow.changeset(%Cow{}, cow_params)

    case Repo.insert(changeset) do
      {:ok, _cow} ->
        conn
        |> put_flash(:info, "Cow created successfully.")
        |> redirect_to(:index)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)
    render(conn, "show.html", cow: cow)
  end

  def edit(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)
    changeset = Cow.changeset(cow)
    render(conn, "edit.html", cow: cow, changeset: changeset)
  end

  def update(conn, %{"id" => id, "cow" => cow_params}) do
    cow = Repo.get!(Cow, id)
    changeset = Cow.changeset(cow, cow_params)

    case Repo.update(changeset) do
      {:ok, cow} ->
        conn
        |> put_flash(:info, "Cow updated successfully.")
        |> redirect_to(:show, cow)
      {:error, changeset} ->
        render(conn, "edit.html", cow: cow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cow)

    conn
    |> put_flash(:info, "Cow deleted successfully.")
    |> redirect_to(:index)
  end
end
