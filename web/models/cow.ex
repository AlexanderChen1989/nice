defmodule Nice.Cow do
  use Nice.Web, :model

  schema "cows" do
    field :name, :string
    belongs_to :cat, Nice.Cat
    many_to_many :pigs, Nice.Pig, join_through: "pig_to_cows"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> cast_assoc(:pigs)
    |> validate_required([:name])
  end
end
