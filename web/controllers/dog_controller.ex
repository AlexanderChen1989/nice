defmodule Nice.DogController do
  use Nice.Web, :controller

  alias Nice.Dog

  def index(conn, params) do
    page = Repo.paginate(Dog, params)
    render(conn, "index.html", page: page, dogs: page.entries)
  end

  def new(conn, _params) do
    changeset = Dog.changeset(%Dog{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"dog" => dog_params}) do
    changeset = Dog.changeset(%Dog{}, dog_params)

    case Repo.insert(changeset) do
      {:ok, _dog} ->
        conn
        |> put_flash(:info, "Dog created successfully.")
        |> redirect(to: dog_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dog = Repo.get!(Dog, id)
    render(conn, "show.html", dog: dog)
  end

  def edit(conn, %{"id" => id}) do
    dog = Repo.get!(Dog, id)
    changeset = Dog.changeset(dog)
    render(conn, "edit.html", dog: dog, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dog" => dog_params}) do
    dog = Repo.get!(Dog, id)
    changeset = Dog.changeset(dog, dog_params)

    case Repo.update(changeset) do
      {:ok, dog} ->
        conn
        |> put_flash(:info, "Dog updated successfully.")
        |> redirect(to: dog_path(conn, :show, dog))
      {:error, changeset} ->
        render(conn, "edit.html", dog: dog, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dog = Repo.get!(Dog, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(dog)

    conn
    |> put_flash(:info, "Dog deleted successfully.")
    |> redirect(to: dog_path(conn, :index))
  end
end
