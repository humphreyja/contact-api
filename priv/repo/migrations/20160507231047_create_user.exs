defmodule ContactApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :auth_id, :string
      add :auth_token, :string
      add :auth_expires_at, :datetime
      add :auth_refresh_token, :string
      add :username, :string
      add :crypted_password, :string

      timestamps
    end
    create unique_index(:users, [:username])

  end
end
