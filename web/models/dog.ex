defmodule Nice.Dog do
  use Nice.Web, :model

  schema "dogs" do
    field :name, :string

    # has_many :cat_to_dogs, CatToDog
    # has_many :cats, through: [:cat_to_dogs, :cat]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
