defmodule Nice.Repo.Migrations.CreateCatToRat do
  use Ecto.Migration

  def change do
    create table(:cat_to_rats) do
      add :cat_id, :integer
      add :rat_id, :integer

      timestamps()
    end

  end
end
