defmodule Nice.CowToCatTest do
  use Nice.ModelCase

  alias Nice.CowToCat

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CowToCat.changeset(%CowToCat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CowToCat.changeset(%CowToCat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
