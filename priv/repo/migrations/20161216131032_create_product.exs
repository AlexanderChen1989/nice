defmodule Nice.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :string
      add :cover, :string
      add :samples, {:array, :string}
      add :summary, :string
      add :polish_print_price, :integer
      add :print_price, :integer
      add :display_type, :string
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end
    create index(:products, [:category_id])

  end
end
