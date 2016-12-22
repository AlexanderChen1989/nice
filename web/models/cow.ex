defmodule Nice.Cow do
  use Nice.Web, :model

  schema "cows" do
    field :name, :string

    many_to_many :cats, Nice.Cat, on_delete: :delete_all, join_through: "cow_to_cats"

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
