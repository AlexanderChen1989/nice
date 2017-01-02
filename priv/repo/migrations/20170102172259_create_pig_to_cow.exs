defmodule Nice.Repo.Migrations.CreatePigToCow do
  use Ecto.Migration

  def change do
    create table(:pig_to_cows) do
      add :pig_id, references(:pigs, on_delete: :nothing)
      add :cow_id, references(:cows, on_delete: :nothing)

      timestamps()
    end
    create index(:pig_to_cows, [:pig_id])
    create index(:pig_to_cows, [:cow_id])

  end
end
