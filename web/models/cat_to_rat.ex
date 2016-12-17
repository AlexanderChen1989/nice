defmodule Nice.CatToRat do
  use Nice.Web, :model

  schema "cat_to_rats" do
    field :cat_id, :integer
    field :rat_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cat_id, :rat_id])
    |> validate_required([:cat_id, :rat_id])
  end
end
