defmodule Nice.CowController do
  use Nice.Web, :controller

  alias Nice.Cow

  def index(conn, params) do
    page =
      if conn.assigns.parent do
        IO.inspect conn.assigns.parent
        conn.assigns.parent_assoc
        |> Repo.paginate(params)
      else
        Repo.paginate(Cow, params)
      end

    render(conn, "index.html", page: page, cows: page.entries)
  end

  def new(conn, _params) do
    changeset = Cow.changeset(%Cow{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"cow" => cow_params}) do
    changeset = Cow.changeset(%Cow{}, cow_params)

    case Repo.insert(changeset) do
      {:ok, _cow} ->
        path =
          if conn.assigns.parent,
            do: cow_path(conn, :index, conn.assigns.parent, []),
          else: cow_path(conn, :index)

        conn
        |> put_flash(:info, "Cow created successfully.")
        |> redirect(to: path)
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
        path =
          if conn.assigns.parent,
            do: cow_path(conn, :show, conn.assigns.parent, cow, []),
          else: cow_path(conn, :show, cow)

        conn
        |> put_flash(:info, "Cow updated successfully.")
        |> redirect(to: path)
      {:error, changeset} ->
        render(conn, "edit.html", cow: cow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cow = Repo.get!(Cow, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cow)

    path =
      if conn.assigns.parent,
        do: cow_path(conn, :index, conn.assigns.parent, []),
      else: cow_path(conn, :index)

    conn
    |> put_flash(:info, "Cow deleted successfully.")
    |> redirect(to: path)
  end
end
