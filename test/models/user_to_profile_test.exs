defmodule Nice.UserToProfileTest do
  use Nice.ModelCase

  alias Nice.UserToProfile

  @valid_attrs %{profile_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserToProfile.changeset(%UserToProfile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserToProfile.changeset(%UserToProfile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
