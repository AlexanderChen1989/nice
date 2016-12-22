defmodule Nice.CatController do
  use Nice.Web, :controller

  alias Nice.Cat


  def index(conn, %{"dog_id" => id} = params) do
    q = from c in Nice.Dog,
      where: [id: ^id],
      preload: :cats,
      select: c

    c = Repo.one(q)

    render(conn, "index.html", cats: c.cats, params: params)
  end

  def index(conn, %{"pig_id" => id} = params) do
    q = from c in Nice.Pig,
      where: [id: ^id],
      preload: :cats,
      select: c

    c = Repo.one(q)

    render(conn, "index.html", cats: c.cats, params: params)
  end

  def index(conn, %{"cow_id" => id} = params) do
    q = from c in Nice.Cow,
      where: [id: ^id],
      preload: :cats,
      select: c

    c = Repo.one(q)

    render(conn, "index.html", cats: c.cats, params: params)
  end


  def index(conn, params) do
    cats = Repo.all(Cat)
    render(conn, "index.html", cats: cats, params: params)
  end

  def new(conn, params) do
    changeset = Cat.changeset(%Cat{})
    render(conn, "new.html", changeset: changeset, params: params)
  end


  def create(conn, %{"cat" => cat_params, "dog_id" => dog_id}) do
    {_, result} =
      Repo.transaction fn ->
        changeset = Cat.changeset(%Cat{}, cat_params)
        with {:ok, %{id:  cat_id}} <- Repo.insert(changeset) do
          ctp_params = %{
            cat_id: cat_id,
            dog_id: dog_id
          }

          %Nice.DogToCat{}
          |> Nice.DogToCat.changeset(ctp_params)
          |> Repo.insert()
        end
      end

    case result do
      {:ok, _cat} ->
        conn
        |> put_flash(:info, "Cat created successfully.")
        |> redirect(to: cat_path(conn, :index, %{"dog_id" => dog_id}))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{"dog_id" => dog_id})
    end
  end

  def create(conn, %{"cat" => cat_params, "pig_id" => pig_id}) do
    {_, result} =
      Repo.transaction fn ->
        changeset = Cat.changeset(%Cat{}, cat_params)
        with {:ok, %{id:  cat_id}} <- Repo.insert(changeset) do
          ctp_params = %{
            cat_id: cat_id,
            pig_id: pig_id
          }

          %Nice.PigToCat{}
          |> Nice.PigToCat.changeset(ctp_params)
          |> Repo.insert()
        end
      end

    case result do
      {:ok, _cat} ->
        conn
        |> put_flash(:info, "Cat created successfully.")
        |> redirect(to: cat_path(conn, :index, %{"pig_id" => pig_id}))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{"pig_id" => pig_id})
    end
  end

  def create(conn, %{"cat" => cat_params, "cow_id" => cow_id}) do
    {_, result} =
      Repo.transaction fn ->
        changeset = Cat.changeset(%Cat{}, cat_params)
        with {:ok, %{id:  cat_id}} <- Repo.insert(changeset) do
          ctp_params = %{
            cat_id: cat_id,
            cow_id: cow_id
          }

          %Nice.CowToCat{}
          |> Nice.CowToCat.changeset(ctp_params)
          |> Repo.insert()
        end
      end

    case result do
      {:ok, _cat} ->
        conn
        |> put_flash(:info, "Cat created successfully.")
        |> redirect(to: cat_path(conn, :index, %{"cow_id" => cow_id}))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{"cow_id" => cow_id})
    end
  end


  def create(conn, %{"cat" => cat_params}) do
    changeset = Cat.changeset(%Cat{}, cat_params)

    case Repo.insert(changeset) do
      {:ok, _cat} ->
        conn
        |> put_flash(:info, "Cat created successfully.")
        |> redirect(to: cat_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{})
    end
  end


  def show(conn, %{"id" => id, "dog_id" => dog_id}) do
    cat = Repo.get!(Cat, id)
    render(conn, "show.html", cat: cat, params: %{"dog_id" => dog_id})
  end

  def show(conn, %{"id" => id, "pig_id" => pig_id}) do
    cat = Repo.get!(Cat, id)
    render(conn, "show.html", cat: cat, params: %{"pig_id" => pig_id})
  end

  def show(conn, %{"id" => id, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)
    render(conn, "show.html", cat: cat, params: %{"cow_id" => cow_id})
  end


  def show(conn, %{"id" => id}) do
    cat = Repo.get!(Cat, id)
    render(conn, "show.html", cat: cat, params: %{})
  end


  def edit(conn, %{"id" => id, "dog_id" => dog_id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat)
    render(conn, "edit.html", cat: cat, changeset: changeset, params: %{"dog_id" => dog_id})
  end

  def edit(conn, %{"id" => id, "pig_id" => pig_id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat)
    render(conn, "edit.html", cat: cat, changeset: changeset, params: %{"pig_id" => pig_id})
  end

  def edit(conn, %{"id" => id, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat)
    render(conn, "edit.html", cat: cat, changeset: changeset, params: %{"cow_id" => cow_id})
  end


  def edit(conn, %{"id" => id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat)
    render(conn, "edit.html", cat: cat, changeset: changeset, params: %{})
  end



  def update(conn, %{"id" => id, "cat" => cat_params, "dog_id" => dog_id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat, cat_params)

    case Repo.update(changeset) do
      {:ok, cat} ->
        conn
        |> put_flash(:info, "Cat updated successfully.")
        |> redirect(to: cat_path(conn, :show, cat, %{"dog_id" => dog_id}))
      {:error, changeset} ->
        render(conn, "edit.html", cat: cat, changeset: changeset, params: %{"dog_id" => dog_id})
    end
  end

  def update(conn, %{"id" => id, "cat" => cat_params, "pig_id" => pig_id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat, cat_params)

    case Repo.update(changeset) do
      {:ok, cat} ->
        conn
        |> put_flash(:info, "Cat updated successfully.")
        |> redirect(to: cat_path(conn, :show, cat, %{"pig_id" => pig_id}))
      {:error, changeset} ->
        render(conn, "edit.html", cat: cat, changeset: changeset, params: %{"pig_id" => pig_id})
    end
  end

  def update(conn, %{"id" => id, "cat" => cat_params, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat, cat_params)

    case Repo.update(changeset) do
      {:ok, cat} ->
        conn
        |> put_flash(:info, "Cat updated successfully.")
        |> redirect(to: cat_path(conn, :show, cat, %{"cow_id" => cow_id}))
      {:error, changeset} ->
        render(conn, "edit.html", cat: cat, changeset: changeset, params: %{"cow_id" => cow_id})
    end
  end


  def update(conn, %{"id" => id, "cat" => cat_params}) do
    cat = Repo.get!(Cat, id)
    changeset = Cat.changeset(cat, cat_params)

    case Repo.update(changeset) do
      {:ok, cat} ->
        conn
        |> put_flash(:info, "Cat updated successfully.")
        |> redirect(to: cat_path(conn, :show, cat))
      {:error, changeset} ->
        render(conn, "edit.html", cat: cat, changeset: changeset, params: %{})
    end
  end


  def delete(conn, %{"id" => id, "dog_id" => dog_id}) do
    cat = Repo.get!(Cat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat)

    conn
    |> put_flash(:info, "Cat deleted successfully.")
    |> redirect(to: cat_path(conn, :index, %{"dog_id" => dog_id}))
  end

  def delete(conn, %{"id" => id, "pig_id" => pig_id}) do
    cat = Repo.get!(Cat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat)

    conn
    |> put_flash(:info, "Cat deleted successfully.")
    |> redirect(to: cat_path(conn, :index, %{"pig_id" => pig_id}))
  end

  def delete(conn, %{"id" => id, "cow_id" => cow_id}) do
    cat = Repo.get!(Cat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat)

    conn
    |> put_flash(:info, "Cat deleted successfully.")
    |> redirect(to: cat_path(conn, :index, %{"cow_id" => cow_id}))
  end


  def delete(conn, %{"id" => id}) do
    cat = Repo.get!(Cat, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cat)

    conn
    |> put_flash(:info, "Cat deleted successfully.")
    |> redirect(to: cat_path(conn, :index))
  end
end
