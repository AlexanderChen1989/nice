defmodule Nice.Repo.Migrations.CreateCowToCat do
  use Ecto.Migration

  def change do
    create table(:cow_to_cats) do
      add :cow_id, references(:cows, on_delete: :nothing)
      add :cat_id, references(:cats, on_delete: :nothing)

      timestamps()
    end

    create index(:cow_to_cats, [:cow_id])
    create index(:cow_to_cats, [:cat_id])
    create unique_index(:cow_to_cats, [:cow_id, :cat_id])
  end
end
