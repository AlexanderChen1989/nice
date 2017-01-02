defmodule Nice.CowControllerTest do
  use Nice.ConnCase

  alias Nice.Cow
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cow_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cows"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, cow_path(conn, :new)
    assert html_response(conn, 200) =~ "New cow"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, cow_path(conn, :create), cow: @valid_attrs
    assert redirected_to(conn) == cow_path(conn, :index)
    assert Repo.get_by(Cow, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cow_path(conn, :create), cow: @invalid_attrs
    assert html_response(conn, 200) =~ "New cow"
  end

  test "shows chosen resource", %{conn: conn} do
    cow = Repo.insert! %Cow{}
    conn = get conn, cow_path(conn, :show, cow)
    assert html_response(conn, 200) =~ "Show cow"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cow_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    cow = Repo.insert! %Cow{}
    conn = get conn, cow_path(conn, :edit, cow)
    assert html_response(conn, 200) =~ "Edit cow"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    cow = Repo.insert! %Cow{}
    conn = put conn, cow_path(conn, :update, cow), cow: @valid_attrs
    assert redirected_to(conn) == cow_path(conn, :show, cow)
    assert Repo.get_by(Cow, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cow = Repo.insert! %Cow{}
    conn = put conn, cow_path(conn, :update, cow), cow: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit cow"
  end

  test "deletes chosen resource", %{conn: conn} do
    cow = Repo.insert! %Cow{}
    conn = delete conn, cow_path(conn, :delete, cow)
    assert redirected_to(conn) == cow_path(conn, :index)
    refute Repo.get(Cow, cow.id)
  end
end
