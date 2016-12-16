defmodule Nice.Profile do
  use Nice.Web, :model

  schema "profiles" do
    field :gender, :string
    field :age, :integer
    field :avatar, :string
    field :marked, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:gender, :age, :avatar])
    |> validate_required([:gender, :age, :avatar])
  end
end
