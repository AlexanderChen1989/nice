defmodule Nice.Cat do
  use Nice.Web, :model

  schema "cats" do
    field :name, :string
    field :age, :integer
    field :marked, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :age])
    |> validate_required([:name, :age])
  end
end
