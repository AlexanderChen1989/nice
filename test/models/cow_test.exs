defmodule Nice.CowTest do
  use Nice.ModelCase

  alias Nice.Cow

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cow.changeset(%Cow{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Cow.changeset(%Cow{}, @invalid_attrs)
    refute changeset.valid?
  end
end
