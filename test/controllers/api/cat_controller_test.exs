defmodule Nice.API.CatControllerTest do
  use Nice.ConnCase

  alias Nice.API.Cat
  @valid_attrs %{age: 42, name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cat_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = get conn, cat_path(conn, :show, cat)
    assert json_response(conn, 200)["data"] == %{"id" => cat.id,
      "name" => cat.name,
      "age" => cat.age}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cat_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, cat_path(conn, :create), cat: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Cat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cat_path(conn, :create), cat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = put conn, cat_path(conn, :update, cat), cat: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Cat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = put conn, cat_path(conn, :update, cat), cat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = delete conn, cat_path(conn, :delete, cat)
    assert response(conn, 204)
    refute Repo.get(Cat, cat.id)
  end
end
