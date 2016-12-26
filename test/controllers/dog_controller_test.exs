defmodule Nice.DogControllerTest do
  use Nice.ConnCase

  alias Nice.Dog
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dog_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing dogs"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, dog_path(conn, :new)
    assert html_response(conn, 200) =~ "New dog"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, dog_path(conn, :create), dog: @valid_attrs
    assert redirected_to(conn) == dog_path(conn, :index)
    assert Repo.get_by(Dog, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, dog_path(conn, :create), dog: @invalid_attrs
    assert html_response(conn, 200) =~ "New dog"
  end

  test "shows chosen resource", %{conn: conn} do
    dog = Repo.insert! %Dog{}
    conn = get conn, dog_path(conn, :show, dog)
    assert html_response(conn, 200) =~ "Show dog"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, dog_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    dog = Repo.insert! %Dog{}
    conn = get conn, dog_path(conn, :edit, dog)
    assert html_response(conn, 200) =~ "Edit dog"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    dog = Repo.insert! %Dog{}
    conn = put conn, dog_path(conn, :update, dog), dog: @valid_attrs
    assert redirected_to(conn) == dog_path(conn, :show, dog)
    assert Repo.get_by(Dog, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    dog = Repo.insert! %Dog{}
    conn = put conn, dog_path(conn, :update, dog), dog: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit dog"
  end

  test "deletes chosen resource", %{conn: conn} do
    dog = Repo.insert! %Dog{}
    conn = delete conn, dog_path(conn, :delete, dog)
    assert redirected_to(conn) == dog_path(conn, :index)
    refute Repo.get(Dog, dog.id)
  end
end
