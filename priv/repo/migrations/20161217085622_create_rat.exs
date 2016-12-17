defmodule Nice.Repo.Migrations.CreateRat do
  use Ecto.Migration

  def change do
    create table(:rats) do
      add :name, :string
      add :agender, :string
      add :height, :decimal

      timestamps()
    end

  end
end
