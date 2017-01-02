defmodule Nice.OwnerTest do
  use Nice.ModelCase

  alias Nice.Owner

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Owner.changeset(%Owner{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Owner.changeset(%Owner{}, @invalid_attrs)
    refute changeset.valid?
  end
end
