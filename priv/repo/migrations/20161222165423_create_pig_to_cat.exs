defmodule Nice.Repo.Migrations.CreatePigToCat do
  use Ecto.Migration

  def change do
    create table(:pig_to_cats) do
      add :pig_id, references(:pigs, on_delete: :nothing)
      add :cat_id, references(:cats, on_delete: :nothing)

      timestamps()
    end
    create index(:pig_to_cats, [:pig_id])

    create unique_index(:pig_to_cats, [:cat_id])
  end
end
