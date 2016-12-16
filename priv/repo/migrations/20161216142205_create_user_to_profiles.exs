defmodule Nice.Repo.Migrations.CreateUserToProfiles do
  use Ecto.Migration

  def change do
    create table(:user_to_profiles) do
      add :user_id, :integer
      add :profile_id, :integer

      timestamps()
    end

  end
end
