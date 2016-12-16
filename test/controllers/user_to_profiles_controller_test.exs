defmodule Nice.UserToProfilesControllerTest do
  use Nice.ConnCase

  alias Nice.UserToProfiles
  @valid_attrs %{profile_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_to_profiles_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing user to profiles"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, user_to_profiles_path(conn, :new)
    assert html_response(conn, 200) =~ "New user to profiles"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, user_to_profiles_path(conn, :create), user_to_profiles: @valid_attrs
    assert redirected_to(conn) == user_to_profiles_path(conn, :index)
    assert Repo.get_by(UserToProfiles, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_to_profiles_path(conn, :create), user_to_profiles: @invalid_attrs
    assert html_response(conn, 200) =~ "New user to profiles"
  end

  test "shows chosen resource", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = get conn, user_to_profiles_path(conn, :show, user_to_profiles)
    assert html_response(conn, 200) =~ "Show user to profiles"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_to_profiles_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = get conn, user_to_profiles_path(conn, :edit, user_to_profiles)
    assert html_response(conn, 200) =~ "Edit user to profiles"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = put conn, user_to_profiles_path(conn, :update, user_to_profiles), user_to_profiles: @valid_attrs
    assert redirected_to(conn) == user_to_profiles_path(conn, :show, user_to_profiles)
    assert Repo.get_by(UserToProfiles, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = put conn, user_to_profiles_path(conn, :update, user_to_profiles), user_to_profiles: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit user to profiles"
  end

  test "deletes chosen resource", %{conn: conn} do
    user_to_profiles = Repo.insert! %UserToProfiles{}
    conn = delete conn, user_to_profiles_path(conn, :delete, user_to_profiles)
    assert redirected_to(conn) == user_to_profiles_path(conn, :index)
    refute Repo.get(UserToProfiles, user_to_profiles.id)
  end
end
