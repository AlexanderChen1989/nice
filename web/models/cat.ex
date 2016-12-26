defmodule Nice.Cat do
  use Nice.Web, :model

  schema "cats" do
    field :name, :string
    belongs_to :dog, Nice.Dog
    belongs_to :pig, Nice.Pig

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
