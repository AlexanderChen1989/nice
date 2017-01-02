defmodule Nice.PigToCowTest do
  use Nice.ModelCase

  alias Nice.PigToCow

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = PigToCow.changeset(%PigToCow{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = PigToCow.changeset(%PigToCow{}, @invalid_attrs)
    refute changeset.valid?
  end
end
