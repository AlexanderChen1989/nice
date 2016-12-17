defmodule Nice.CatToRatControllerTest do
  use Nice.ConnCase

  alias Nice.CatToRat
  @valid_attrs %{cat_id: 42, rat_id: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cat_to_rat_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing cat to rats"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, cat_to_rat_path(conn, :new)
    assert html_response(conn, 200) =~ "New cat to rat"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, cat_to_rat_path(conn, :create), cat_to_rat: @valid_attrs
    assert redirected_to(conn) == cat_to_rat_path(conn, :index)
    assert Repo.get_by(CatToRat, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cat_to_rat_path(conn, :create), cat_to_rat: @invalid_attrs
    assert html_response(conn, 200) =~ "New cat to rat"
  end

  test "shows chosen resource", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = get conn, cat_to_rat_path(conn, :show, cat_to_rat)
    assert html_response(conn, 200) =~ "Show cat to rat"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cat_to_rat_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = get conn, cat_to_rat_path(conn, :edit, cat_to_rat)
    assert html_response(conn, 200) =~ "Edit cat to rat"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = put conn, cat_to_rat_path(conn, :update, cat_to_rat), cat_to_rat: @valid_attrs
    assert redirected_to(conn) == cat_to_rat_path(conn, :show, cat_to_rat)
    assert Repo.get_by(CatToRat, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = put conn, cat_to_rat_path(conn, :update, cat_to_rat), cat_to_rat: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit cat to rat"
  end

  test "deletes chosen resource", %{conn: conn} do
    cat_to_rat = Repo.insert! %CatToRat{}
    conn = delete conn, cat_to_rat_path(conn, :delete, cat_to_rat)
    assert redirected_to(conn) == cat_to_rat_path(conn, :index)
    refute Repo.get(CatToRat, cat_to_rat.id)
  end
end
