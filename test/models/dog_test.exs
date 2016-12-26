defmodule Nice.DogTest do
  use Nice.ModelCase

  alias Nice.Dog

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Dog.changeset(%Dog{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Dog.changeset(%Dog{}, @invalid_attrs)
    refute changeset.valid?
  end
end
