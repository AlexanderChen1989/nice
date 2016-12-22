defmodule Nice.Repo.Migrations.CreateDogToCat do
  use Ecto.Migration

  def change do
    create table(:dog_to_cats) do
      add :dog_id, references(:dogs, on_delete: :nothing)
      add :cat_id, references(:cats, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:dog_to_cats, [:dog_id])
    create unique_index(:dog_to_cats, [:cat_id])
  end
end
