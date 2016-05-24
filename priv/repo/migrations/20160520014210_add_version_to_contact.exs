defmodule ContactApi.Repo.Migrations.AddVersionToContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      add :data_version, :integer, default: 0
      add :data_update_time, :integer, default: 0
    end
  end
end
