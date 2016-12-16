defmodule Nice.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :gender, :string
      add :age, :integer
      add :avatar, :string

      timestamps()
    end

  end
end
