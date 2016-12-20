defmodule Nice.User do
  use Nice.Web, :model

  schema "users" do
    field :name, :string

    many_to_many :profiles, Nice.Profile, on_delete: :delete_all, join_through: "user_to_profiles"

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
