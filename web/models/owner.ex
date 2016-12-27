defmodule Nice.Owner do
  use Nice.Web, :model

  schema "owners" do
    field :name, :string

    many_to_many :cats, Nice.Cat, join_through: "owner_to_cats", on_delete: :delete_all
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
    |> cast_assoc(:cats)

  end
end
