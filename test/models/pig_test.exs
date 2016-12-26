defmodule Nice.PigTest do
  use Nice.ModelCase

  alias Nice.Pig

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pig.changeset(%Pig{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pig.changeset(%Pig{}, @invalid_attrs)
    refute changeset.valid?
  end
end
