defmodule Nice.User do
  use Nice.Web, :model

  schema "users" do
    field :name, :string
    field :password, :string
    field :marked, :boolean, virtual: true, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :password])
    |> validate_required([:name, :password])
  end
end
