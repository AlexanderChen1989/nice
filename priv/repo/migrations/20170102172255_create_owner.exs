defmodule Nice.Repo.Migrations.CreateOwner do
  use Ecto.Migration

  def change do
    create table(:owners) do
      add :name, :string

      timestamps()
    end

  end
end
