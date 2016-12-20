defmodule Nice.ProfileController do
  use Nice.Web, :controller

  alias Nice.Profile


  def index(conn, %{"user_id" => id} = params) do
    q = from c in Nice.User,
      where: [id: ^id],
      preload: :profiles,
      select: c

    c = Repo.one(q)

    render(conn, "index.html", profiles: c.profiles, params: params)
  end


  def index(conn, params) do
    profiles = Repo.all(Profile)
    render(conn, "index.html", profiles: profiles, params: params)
  end

  def new(conn, params) do
    changeset = Profile.changeset(%Profile{})
    render(conn, "new.html", changeset: changeset, params: params)
  end


  def create(conn, %{"profile" => profile_params, "user_id" => user_id}) do
    {_, result} =
      Repo.transaction fn ->
        changeset = Profile.changeset(%Profile{}, profile_params)
        with {:ok, %{id:  profile_id}} <- Repo.insert(changeset) do
          ctp_params = %{
            profile_id: profile_id,
            user_id: user_id
          }

          %Nice.UserToProfile{}
          |> Nice.UserToProfile.changeset(ctp_params)
          |> Repo.insert()
        end
      end

    case result do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile created successfully.")
        |> redirect(to: profile_path(conn, :index, %{"user_id" => user_id}))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{"user_id" => user_id})
    end
  end


  def create(conn, %{"profile" => profile_params}) do
    changeset = Profile.changeset(%Profile{}, profile_params)

    case Repo.insert(changeset) do
      {:ok, _profile} ->
        conn
        |> put_flash(:info, "Profile created successfully.")
        |> redirect(to: profile_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, params: %{})
    end
  end


  def show(conn, %{"id" => id, "user_id" => user_id}) do
    profile = Repo.get!(Profile, id)
    render(conn, "show.html", profile: profile, params: %{"user_id" => user_id})
  end


  def show(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    render(conn, "show.html", profile: profile, params: %{})
  end


  def edit(conn, %{"id" => id, "user_id" => user_id}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.changeset(profile)
    render(conn, "edit.html", profile: profile, changeset: changeset, params: %{"user_id" => user_id})
  end


  def edit(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.changeset(profile)
    render(conn, "edit.html", profile: profile, changeset: changeset, params: %{})
  end



  def update(conn, %{"id" => id, "profile" => profile_params, "user_id" => user_id}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.changeset(profile, profile_params)

    case Repo.update(changeset) do
      {:ok, profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: profile_path(conn, :show, profile, %{"user_id" => user_id}))
      {:error, changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset, params: %{"user_id" => user_id})
    end
  end


  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.changeset(profile, profile_params)

    case Repo.update(changeset) do
      {:ok, profile} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: profile_path(conn, :show, profile))
      {:error, changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset, params: %{})
    end
  end


  def delete(conn, %{"id" => id, "user_id" => user_id}) do
    profile = Repo.get!(Profile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(profile)

    conn
    |> put_flash(:info, "Profile deleted successfully.")
    |> redirect(to: profile_path(conn, :index, %{"user_id" => user_id}))
  end


  def delete(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(profile)

    conn
    |> put_flash(:info, "Profile deleted successfully.")
    |> redirect(to: profile_path(conn, :index))
  end
end
