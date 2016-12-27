defmodule Nice.Repo.Migrations.CreateOwnerToCat do
  use Ecto.Migration

  def change do
    create table(:owner_to_cats) do
      add :owner_id, references(:owners, on_delete: :nothing)
      add :cat_id, references(:cats, on_delete: :nothing)

    end
    create index(:owner_to_cats, [:owner_id])
    create index(:owner_to_cats, [:cat_id])

  end
end
