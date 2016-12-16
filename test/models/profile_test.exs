defmodule Nice.ProfileTest do
  use Nice.ModelCase

  alias Nice.Profile

  @valid_attrs %{age: 42, avatar: "some content", gender: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Profile.changeset(%Profile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Profile.changeset(%Profile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
