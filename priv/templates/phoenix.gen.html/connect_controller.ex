defmodule Nice.UserToProfilesConnectController do
  use Nice.Web, :controller

  require Logger

  alias Nice.UserToProfiles
  alias Nice.User
  alias Nice.Profile

  def toggle(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse
    {to, _} = Map.get(params, "to", "-1") |> Integer.parse

    if from != -1 and to != -1 do
      toggle_connection(from, to)
    end

    redirect conn, to: user_to_profiles_connect_path(conn, :connect, from: from)
  end

  def connect(conn, params) do
    {from, _} = Map.get(params, "from", "-1") |> Integer.parse

    users =
      Repo.all(User)
      |> mark_item(&(&1.id == from))

    profile_ids =
      Repo.all(UserToProfiles)
      |> Enum.filter_map(& &1.user_id == from, & &1.profile_id)

    profiles =
      Repo.all(Profile)
      |> mark_item(& &1.id in profile_ids)

    render(conn, "connect.html", users: users, profiles: profiles, from: from)
  end

  defp toggle_connection(from, to) do
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
end
