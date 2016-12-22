defmodule Nice.DogToCatTest do
  use Nice.ModelCase

  alias Nice.DogToCat

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DogToCat.changeset(%DogToCat{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DogToCat.changeset(%DogToCat{}, @invalid_attrs)
    refute changeset.valid?
  end
end
