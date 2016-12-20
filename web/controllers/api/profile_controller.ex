defmodule Nice.API.ProfileController do
  use Nice.Web, :controller

  alias Nice.Profile

  def index(conn, _params) do
    profiles = Repo.all(Profile)
    render(conn, "index.json", profiles: profiles)
  end

  def create(conn, %{"profile" => profile_params}) do
    changeset = Profile.changeset(%Profile{}, profile_params)

    case Repo.insert(changeset) do
      {:ok, profile} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", profile_path(conn, :show, profile))
        |> render("show.json", profile: profile)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    render(conn, "show.json", profile: profile)
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    profile = Repo.get!(Profile, id)
    changeset = Profile.changeset(profile, profile_params)

    case Repo.update(changeset) do
      {:ok, profile} ->
        render(conn, "show.json", profile: profile)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Nice.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(profile)

    send_resp(conn, :no_content, "")
  end
end
