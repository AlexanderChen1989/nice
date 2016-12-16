defmodule Nice.API.GoodGroupControllerTest do
  use Nice.ConnCase

  alias Nice.API.GoodGroup
  @valid_attrs %{max_selection: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, good_group_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = get conn, good_group_path(conn, :show, good_group)
    assert json_response(conn, 200)["data"] == %{"id" => good_group.id,
      "product_id" => good_group.product_id,
      "name" => good_group.name,
      "max_selection" => good_group.max_selection}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, good_group_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, good_group_path(conn, :create), good_group: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(GoodGroup, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, good_group_path(conn, :create), good_group: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = put conn, good_group_path(conn, :update, good_group), good_group: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(GoodGroup, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = put conn, good_group_path(conn, :update, good_group), good_group: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = delete conn, good_group_path(conn, :delete, good_group)
    assert response(conn, 204)
    refute Repo.get(GoodGroup, good_group.id)
  end
end
