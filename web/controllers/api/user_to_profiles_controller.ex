defmodule Nice.API.UserToProfilesController do
  use Nice.Web, :controller

  alias Nice.UserToProfiles

  def index(conn, _params) do
    user_to_profiles = Repo.all(UserToProfiles)
    render(conn, "index.json", user_to_profiles: user_to_profiles)
  end

  def create(conn, %{"user_to_profiles" => user_to_profiles_params}) do
    changeset = UserToProfiles.changeset(%UserToProfiles{}, user_to_profiles_params)

    case Repo.insert(changeset) do
      {:ok, user_to_profiles} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_to_profiles_path(conn, :show, user_to_profiles))
        |> render("show.json", user_to_profiles: user_to_profiles)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)
    render(conn, "show.json", user_to_profiles: user_to_profiles)
  end

  def update(conn, %{"id" => id, "user_to_profiles" => user_to_profiles_params}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)
    changeset = UserToProfiles.changeset(user_to_profiles, user_to_profiles_params)

    case Repo.update(changeset) do
      {:ok, user_to_profiles} ->
        render(conn, "show.json", user_to_profiles: user_to_profiles)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_to_profiles = Repo.get!(UserToProfiles, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user_to_profiles)

    send_resp(conn, :no_content, "")
  end
end
