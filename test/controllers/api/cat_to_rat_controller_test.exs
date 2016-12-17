defmodule Nice.API.CatToRatControllerTest do
  use Nice.ConnCase

  alias Nice.API.CatToRat
  @valid_attrs %{cat_id: 42, rat_id: 42}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cat_to_rat_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = get conn, cat_to_rat_path(conn, :show, cat_to_rat)
    assert json_response(conn, 200)["data"] == %{"id" => cat_to_rat.id,
      "cat_id" => cat_to_rat.cat_id,
      "rat_id" => cat_to_rat.rat_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cat_to_rat_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, cat_to_rat_path(conn, :create), cat_to_rat: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CatToRat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cat_to_rat_path(conn, :create), cat_to_rat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = put conn, cat_to_rat_path(conn, :update, cat_to_rat), cat_to_rat: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CatToRat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = put conn, cat_to_rat_path(conn, :update, cat_to_rat), cat_to_rat: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = delete conn, cat_to_rat_path(conn, :delete, cat_to_rat)
    assert response(conn, 204)
    refute Repo.get(CatToRat, cat_to_rat.id)
  end
end
