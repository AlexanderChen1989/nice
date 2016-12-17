defmodule Nice.RatControllerTest do
  use Nice.ConnCase

  alias Nice.Rat
  @valid_attrs %{agender: "some content", height: "120.5", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, rat_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing rats"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, rat_path(conn, :new)
    assert html_response(conn, 200) =~ "New rat"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, rat_path(conn, :create), rat: @valid_attrs
    assert redirected_to(conn) == rat_path(conn, :index)
    assert Repo.get_by(Rat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, rat_path(conn, :create), rat: @invalid_attrs
    assert html_response(conn, 200) =~ "New rat"
  end

  test "shows chosen resource", %{conn: conn} do
    rat = Repo.insert! %Rat{}
    conn = get conn, rat_path(conn, :show, rat)
    assert html_response(conn, 200) =~ "Show rat"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, rat_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    rat = Repo.insert! %Rat{}
    conn = get conn, rat_path(conn, :edit, rat)
    assert html_response(conn, 200) =~ "Edit rat"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    rat = Repo.insert! %Rat{}
    conn = put conn, rat_path(conn, :update, rat), rat: @valid_attrs
    assert redirected_to(conn) == rat_path(conn, :show, rat)
    assert Repo.get_by(Rat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    rat = Repo.insert! %Rat{}
    conn = put conn, rat_path(conn, :update, rat), rat: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit rat"
  end

  test "deletes chosen resource", %{conn: conn} do
    rat = Repo.insert! %Rat{}
    conn = delete conn, rat_path(conn, :delete, rat)
    assert redirected_to(conn) == rat_path(conn, :index)
    refute Repo.get(Rat, rat.id)
  end
end
