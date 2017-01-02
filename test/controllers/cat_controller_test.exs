defmodule Nice.CatControllerTest do
  use Nice.ConnCase

  alias Nice.Cat
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cat_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cats"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, cat_path(conn, :new)
    assert html_response(conn, 200) =~ "New cat"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, cat_path(conn, :create), cat: @valid_attrs
    assert redirected_to(conn) == cat_path(conn, :index)
    assert Repo.get_by(Cat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cat_path(conn, :create), cat: @invalid_attrs
    assert html_response(conn, 200) =~ "New cat"
  end

  test "shows chosen resource", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = get conn, cat_path(conn, :show, cat)
    assert html_response(conn, 200) =~ "Show cat"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cat_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = get conn, cat_path(conn, :edit, cat)
    assert html_response(conn, 200) =~ "Edit cat"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = put conn, cat_path(conn, :update, cat), cat: @valid_attrs
    assert redirected_to(conn) == cat_path(conn, :show, cat)
    assert Repo.get_by(Cat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = put conn, cat_path(conn, :update, cat), cat: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit cat"
  end

  test "deletes chosen resource", %{conn: conn} do
    cat = Repo.insert! %Cat{}
    conn = delete conn, cat_path(conn, :delete, cat)
    assert redirected_to(conn) == cat_path(conn, :index)
    refute Repo.get(Cat, cat.id)
  end
end
