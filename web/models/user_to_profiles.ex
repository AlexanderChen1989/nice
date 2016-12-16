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

  def find(user_id, profile_id) do
    from u in Nice.UserToProfiles,
      where: u.user_id == ^user_id and u.profile_id == ^profile_id,
      select: u
  end
end
