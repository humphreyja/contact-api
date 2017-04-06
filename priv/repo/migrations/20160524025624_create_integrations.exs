defmodule ContactApi.Repo.Migrations.CreateIntegrations do
  use Ecto.Migration

  def change do
    create table(:integrations) do
      add :name, :string
      add :auth_data, :string
      timestamps
    end
  end
end
