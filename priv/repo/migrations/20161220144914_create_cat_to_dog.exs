defmodule Nice.Repo.Migrations.CreateCatToDog do
  use Ecto.Migration

  def change do
    create table(:cat_to_dogs) do
      add :cat_id, references(:cats, on_delete: :nothing)
      add :dog_id, references(:dogs, on_delete: :nothing)

      timestamps()
    end
    create index(:cat_to_dogs, [:cat_id])
    create index(:cat_to_dogs, [:dog_id])

  end
end
