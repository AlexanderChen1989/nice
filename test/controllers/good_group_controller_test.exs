defmodule Nice.GoodGroupControllerTest do
  use Nice.ConnCase

  alias Nice.GoodGroup
  @valid_attrs %{max_selection: 42, name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, good_group_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing good groups"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, good_group_path(conn, :new)
    assert html_response(conn, 200) =~ "New good group"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, good_group_path(conn, :create), good_group: @valid_attrs
    assert redirected_to(conn) == good_group_path(conn, :index)
    assert Repo.get_by(GoodGroup, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, good_group_path(conn, :create), good_group: @invalid_attrs
    assert html_response(conn, 200) =~ "New good group"
  end

  test "shows chosen resource", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = get conn, good_group_path(conn, :show, good_group)
    assert html_response(conn, 200) =~ "Show good group"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, good_group_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = get conn, good_group_path(conn, :edit, good_group)
    assert html_response(conn, 200) =~ "Edit good group"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = put conn, good_group_path(conn, :update, good_group), good_group: @valid_attrs
    assert redirected_to(conn) == good_group_path(conn, :show, good_group)
    assert Repo.get_by(GoodGroup, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = put conn, good_group_path(conn, :update, good_group), good_group: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit good group"
  end

  test "deletes chosen resource", %{conn: conn} do
    good_group = Repo.insert! %GoodGroup{}
    conn = delete conn, good_group_path(conn, :delete, good_group)
    assert redirected_to(conn) == good_group_path(conn, :index)
    refute Repo.get(GoodGroup, good_group.id)
  end
end
