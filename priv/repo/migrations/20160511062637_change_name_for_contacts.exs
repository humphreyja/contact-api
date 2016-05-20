defmodule ContactApi.Repo.Migrations.ChangeNameForContacts do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      remove :first_name
      remove :last_name
      add :name, :string
    end
  end
end
