defmodule Nice.Cat do
  use Nice.Web, :model

  schema "cats" do
    field :name, :string

    has_one :cat_to_dog, Nice.CatToDog
    has_one :pet, through: [:cat_to_dog, :dog]
    has_many :cat_to_dogs, Nice.CatToDog
    has_many :pets, through: [:cat_to_dogs, :dog]
    many_to_many :dogs, Nice.Dog, join_through: Nice.CatToDog
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
