defmodule Nice.OwnerToCat do
  use Nice.Web, :model

  schema "owner_to_cats" do
    belongs_to :owner, Nice.Owner
    belongs_to :cat, Nice.Cat
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
