defmodule Nice.UserToProfiles do
  use Nice.Web, :model

  schema "user_to_profiles" do
    field :user_id, :integer
    field :profile_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :profile_id])
    |> validate_required([:user_id, :profile_id])
  end
end
