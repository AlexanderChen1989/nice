defmodule Nice.GoodGroupTest do
  use Nice.ModelCase

  alias Nice.GoodGroup

  @valid_attrs %{max_selection: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = GoodGroup.changeset(%GoodGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = GoodGroup.changeset(%GoodGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
