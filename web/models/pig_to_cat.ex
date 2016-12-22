defmodule Nice.PigToCat do
  use Nice.Web, :model

  schema "pig_to_cats" do
    belongs_to :pig, Nice.Pig
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
