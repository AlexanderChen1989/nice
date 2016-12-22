defmodule Nice.Repo.Migrations.CreatePig do
  use Ecto.Migration

  def change do
    create table(:pigs) do
      add :name, :string

      timestamps()
    end

  end
end
