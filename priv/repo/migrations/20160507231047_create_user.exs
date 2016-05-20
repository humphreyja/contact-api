defmodule ContactApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :username, :string
      add :crypted_password, :string

      timestamps
    end
    create unique_index(:users, [:username])

  end
end
