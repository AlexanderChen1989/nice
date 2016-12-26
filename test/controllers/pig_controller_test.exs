defmodule Nice.PigControllerTest do
  use Nice.ConnCase

  alias Nice.Pig
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pig_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing pigs"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, pig_path(conn, :new)
    assert html_response(conn, 200) =~ "New pig"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, pig_path(conn, :create), pig: @valid_attrs
    assert redirected_to(conn) == pig_path(conn, :index)
    assert Repo.get_by(Pig, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pig_path(conn, :create), pig: @invalid_attrs
    assert html_response(conn, 200) =~ "New pig"
  end

  test "shows chosen resource", %{conn: conn} do
    pig = Repo.insert! %Pig{}
    conn = get conn, pig_path(conn, :show, pig)
    assert html_response(conn, 200) =~ "Show pig"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pig_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    pig = Repo.insert! %Pig{}
    conn = get conn, pig_path(conn, :edit, pig)
    assert html_response(conn, 200) =~ "Edit pig"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    pig = Repo.insert! %Pig{}
    conn = put conn, pig_path(conn, :update, pig), pig: @valid_attrs
    assert redirected_to(conn) == pig_path(conn, :show, pig)
    assert Repo.get_by(Pig, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pig = Repo.insert! %Pig{}
    conn = put conn, pig_path(conn, :update, pig), pig: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit pig"
  end

  test "deletes chosen resource", %{conn: conn} do
    pig = Repo.insert! %Pig{}
    conn = delete conn, pig_path(conn, :delete, pig)
    assert redirected_to(conn) == pig_path(conn, :index)
    refute Repo.get(Pig, pig.id)
  end
end
