defmodule Nice.Cow do
  use Nice.Web, :model

  schema "cows" do
    field :name, :string
    belongs_to :cat, Nice.Cat

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
