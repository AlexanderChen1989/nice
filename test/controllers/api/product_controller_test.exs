defmodule Nice.API.ProductControllerTest do
  use Nice.ConnCase

  alias Nice.API.Product
  @valid_attrs %{cover: "some content", description: "some content", display_type: "some content", name: "some content", polish_print_price: 42, print_price: 42, samples: [], summary: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, product_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = get conn, product_path(conn, :show, product)
    assert json_response(conn, 200)["data"] == %{"id" => product.id,
      "category_id" => product.category_id,
      "name" => product.name,
      "description" => product.description,
      "cover" => product.cover,
      "samples" => product.samples,
      "summary" => product.summary,
      "polish_print_price" => product.polish_print_price,
      "print_price" => product.print_price,
      "display_type" => product.display_type}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, product_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, product_path(conn, :create), product: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, product_path(conn, :create), product: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = put conn, product_path(conn, :update, product), product: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = put conn, product_path(conn, :update, product), product: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = delete conn, product_path(conn, :delete, product)
    assert response(conn, 204)
    refute Repo.get(Product, product.id)
  end
end
