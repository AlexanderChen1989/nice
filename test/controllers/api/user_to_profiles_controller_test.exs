defmodule Nice.API.UserToProfilesControllerTest do
  use Nice.ConnCase

  alias Nice.API.UserToProfiles
  @valid_attrs %{profile_id: 42, user_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_to_profiles_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = get conn, user_to_profiles_path(conn, :show, user_to_profiles)
    assert json_response(conn, 200)["data"] == %{"id" => user_to_profiles.id,
      "user_id" => user_to_profiles.user_id,
      "profile_id" => user_to_profiles.profile_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_to_profiles_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_to_profiles_path(conn, :create), user_to_profiles: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(UserToProfiles, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_to_profiles_path(conn, :create), user_to_profiles: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = put conn, user_to_profiles_path(conn, :update, user_to_profiles), user_to_profiles: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(UserToProfiles, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = put conn, user_to_profiles_path(conn, :update, user_to_profiles), user_to_profiles: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = delete conn, user_to_profiles_path(conn, :delete, user_to_profiles)
    assert response(conn, 204)
    refute Repo.get(UserToProfiles, user_to_profiles.id)
  end
end
