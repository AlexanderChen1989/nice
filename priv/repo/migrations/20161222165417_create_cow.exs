defmodule Nice.Repo.Migrations.CreateCow do
  use Ecto.Migration

  def change do
    create table(:cows) do
      add :name, :string

      timestamps()
    end

  end
end
