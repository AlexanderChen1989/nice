defmodule Nice.UserToProfilesController do
  use Nice.Web, :controller

  alias Nice.UserToProfiles

  def index(conn, _params) do
    user_to_profiles = Repo.all(UserToProfiles)
    render(conn, "index.html", user_to_profiles: user_to_profiles)
  end

  def new(conn, _params) do
    changeset = UserToProfiles.changeset(%UserToProfiles{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_to_profiles" => user_to_profiles_params}) do
    changeset = UserToProfiles.changeset(%UserToProfiles{}, user_to_profiles_params)

    case Repo.insert(changeset) do
      {:ok, _user_to_profiles} ->
        conn
        |> put_flash(:info, "User to profiles created successfully.")
        |> redirect(to: user_to_profiles_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)
    render(conn, "show.html", user_to_profiles: user_to_profiles)
  end

  def edit(conn, %{"id" => id}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)
    changeset = UserToProfiles.changeset(user_to_profiles)
    render(conn, "edit.html", user_to_profiles: user_to_profiles, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_to_profiles" => user_to_profiles_params}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)
    changeset = UserToProfiles.changeset(user_to_profiles, user_to_profiles_params)

    case Repo.update(changeset) do
      {:ok, user_to_profiles} ->
        conn
        |> put_flash(:info, "User to profiles updated successfully.")
        |> redirect(to: user_to_profiles_path(conn, :show, user_to_profiles))
      {:error, changeset} ->
        render(conn, "edit.html", user_to_profiles: user_to_profiles, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_to_profiles)

    conn
    |> put_flash(:info, "User to profiles deleted successfully.")
    |> redirect(to: user_to_profiles_path(conn, :index))
  end
end
