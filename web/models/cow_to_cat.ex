defmodule Nice.CowToCat do
  use Nice.Web, :model

  schema "cow_to_cats" do
    belongs_to :cow, Nice.Cow
    belongs_to :cat, Nice.Cat

    timestamps()
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
