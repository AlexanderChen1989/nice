defmodule Nice.Repo.Migrations.CreateCat do
  use Ecto.Migration

  def change do
    create table(:cats) do
      add :name, :string
      add :dog_id, references(:dogs, on_delete: :nothing)
      add :pig_id, references(:pigs, on_delete: :nothing)

      timestamps()
    end
    create index(:cats, [:dog_id])
    create index(:cats, [:pig_id])

  end
end
