defmodule Nice.PigToCatTest do
  use Nice.ModelCase

  alias Nice.PigToCat

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PigToCat.changeset(%PigToCat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PigToCat.changeset(%PigToCat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
