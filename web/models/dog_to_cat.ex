defmodule Nice.DogToCat do
  use Nice.Web, :model

  schema "dog_to_cats" do
    belongs_to :dog, Nice.Dog
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
