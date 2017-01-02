defmodule Nice.OwnerControllerTest do
  use Nice.ConnCase

  alias Nice.Owner
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, owner_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing owners"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, owner_path(conn, :new)
    assert html_response(conn, 200) =~ "New owner"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, owner_path(conn, :create), owner: @valid_attrs
    assert redirected_to(conn) == owner_path(conn, :index)
    assert Repo.get_by(Owner, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, owner_path(conn, :create), owner: @invalid_attrs
    assert html_response(conn, 200) =~ "New owner"
  end

  test "shows chosen resource", %{conn: conn} do
    owner = Repo.insert! %Owner{}
    conn = get conn, owner_path(conn, :show, owner)
    assert html_response(conn, 200) =~ "Show owner"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, owner_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    owner = Repo.insert! %Owner{}
    conn = get conn, owner_path(conn, :edit, owner)
    assert html_response(conn, 200) =~ "Edit owner"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    owner = Repo.insert! %Owner{}
    conn = put conn, owner_path(conn, :update, owner), owner: @valid_attrs
    assert redirected_to(conn) == owner_path(conn, :show, owner)
    assert Repo.get_by(Owner, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    owner = Repo.insert! %Owner{}
    conn = put conn, owner_path(conn, :update, owner), owner: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit owner"
  end

  test "deletes chosen resource", %{conn: conn} do
    owner = Repo.insert! %Owner{}
    conn = delete conn, owner_path(conn, :delete, owner)
    assert redirected_to(conn) == owner_path(conn, :index)
    refute Repo.get(Owner, owner.id)
  end
end
