defmodule Nice.CatToRatTest do
  use Nice.ModelCase

  alias Nice.CatToRat

  @valid_attrs %{cat_id: 42, rat_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CatToRat.changeset(%CatToRat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CatToRat.changeset(%CatToRat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
