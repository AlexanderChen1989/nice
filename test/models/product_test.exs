defmodule Nice.ProductTest do
  use Nice.ModelCase

  alias Nice.Product

  @valid_attrs %{cover: "some content", description: "some content", display_type: "some content", name: "some content", polish_print_price: 42, print_price: 42, samples: [], summary: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
