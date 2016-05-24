defmodule ContactApi.Repo.Migrations.CreateApiToken do
  use Ecto.Migration

  def change do
    create table(:api_tokens) do
      add :token, :string
      add :name, :string

      timestamps
    end

  end
end
