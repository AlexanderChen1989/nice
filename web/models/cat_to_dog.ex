defmodule Nice.CatToDog do
  use Nice.Web, :model

  schema "cat_to_dogs" do
    belongs_to :cat, Nice.Cat
    belongs_to :dog, Nice.Dog

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
