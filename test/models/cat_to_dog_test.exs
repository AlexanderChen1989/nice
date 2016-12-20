defmodule Nice.CatToDogTest do
  use Nice.ModelCase

  alias Nice.CatToDog

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CatToDog.changeset(%CatToDog{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CatToDog.changeset(%CatToDog{}, @invalid_attrs)
    refute changeset.valid?
  end
end
