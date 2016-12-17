defmodule Nice.Rat do
  use Nice.Web, :model

  schema "rats" do
    field :name, :string
    field :agender, :string
    field :height, :decimal
    field :marked, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :agender, :height])
    |> validate_required([:name, :agender, :height])
  end
end
