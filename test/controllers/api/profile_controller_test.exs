defmodule Nice.API.ProfileControllerTest do
  use Nice.ConnCase

  alias Nice.API.Profile
  @valid_attrs %{age: 42, avatar: "some content", gender: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, profile_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    profile = Repo.insert! %Profile{}
    conn = get conn, profile_path(conn, :show, profile)
    assert json_response(conn, 200)["data"] == %{"id" => profile.id,
      "gender" => profile.gender,
      "age" => profile.age,
      "avatar" => profile.avatar}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, profile_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, profile_path(conn, :create), profile: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Profile, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, profile_path(conn, :create), profile: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    profile = Repo.insert! %Profile{}
    conn = put conn, profile_path(conn, :update, profile), profile: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Profile, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    profile = Repo.insert! %Profile{}
    conn = put conn, profile_path(conn, :update, profile), profile: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    profile = Repo.insert! %Profile{}
    conn = delete conn, profile_path(conn, :delete, profile)
    assert response(conn, 204)
    refute Repo.get(Profile, profile.id)
  end
end
