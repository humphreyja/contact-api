defmodule ContactApi.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :phone_number, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:contacts, [:user_id])

  end
end
