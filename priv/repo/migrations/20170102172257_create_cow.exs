defmodule Nice.Repo.Migrations.CreateCow do
  use Ecto.Migration

  def change do
    create table(:cows) do
      add :name, :string
      add :cat_id, references(:cats, on_delete: :nothing)

      timestamps()
    end
    create index(:cows, [:cat_id])

  end
end
