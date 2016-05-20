defmodule ContactApi.Repo.Migrations.AddVersionToContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :version, :string
    end
  end
end
