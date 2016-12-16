defmodule Nice.Product do
  use Nice.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :cover, :string
    field :samples, {:array, :string}
    field :summary, :string
    field :polish_print_price, :integer
    field :print_price, :integer
    field :display_type, :string
    belongs_to :category, Nice.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :cover, :samples, :summary, :polish_print_price, :print_price, :display_type])
    |> validate_required([:name, :description, :cover, :samples, :summary, :polish_print_price, :print_price, :display_type])
  end
end
