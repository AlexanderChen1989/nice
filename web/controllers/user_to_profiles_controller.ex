defmodule Nice.UserToProfilesController do
  use Nice.Web, :controller

  require Logger

  alias Nice.UserToProfiles
  alias Nice.User
  alias Nice.Profile

  def both(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle(from, to)
    end

    users =
      Repo.all(User)
      |> mark_item(&(&1.id == from))

    profile_ids =
      Repo.all(UserToProfiles)
      |> Enum.filter_map(& &1.user_id == from, & &1.profile_id)

    profiles =
      Repo.all(Profile)
      |> mark_item(& &1.id in profile_ids)


    render(conn, "both.html", users: users, profiles: profiles, from: from, to: to)
  end

  defp toggle(from, to) do
    case UserToProfiles.find(from, to) |> Repo.all() do
      [] ->
        %UserToProfiles{user_id: from, profile_id: to} |> Repo.insert
      ups ->
        ups |> Enum.each(&Repo.delete/1)
    end
  end

  defp mark_item(items, check) do
    List.foldr(items, [], fn item, acc ->
      if check.(item) do
        [%{item | marked: true} | acc]
      else
        [%{item | marked: false} | acc]
      end
    end)
  end

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
