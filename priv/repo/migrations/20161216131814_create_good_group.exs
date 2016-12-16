defmodule Nice.Repo.Migrations.CreateGoodGroup do
  use Ecto.Migration

  def change do
    create table(:good_groups) do
      add :name, :string
      add :max_selection, :integer
      add :product_id, references(:products, on_delete: :nothing)

      timestamps()
    end
    create index(:good_groups, [:product_id])

  end
end
