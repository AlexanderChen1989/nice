defmodule Nice.UserToProfilesTest do
  use Nice.ModelCase

  alias Nice.UserToProfiles

  @valid_attrs %{profile_id: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = UserToProfiles.changeset(%UserToProfiles{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserToProfiles.changeset(%UserToProfiles{}, @invalid_attrs)
    refute changeset.valid?
  end
end
