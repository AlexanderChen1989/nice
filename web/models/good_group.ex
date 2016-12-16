defmodule Nice.GoodGroup do
  use Nice.Web, :model

  schema "good_groups" do
    field :name, :string
    field :max_selection, :integer
    belongs_to :product, Nice.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :max_selection])
    |> validate_required([:name, :max_selection])
  end
end
