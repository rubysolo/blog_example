defmodule Blergh.Repo.Migrations.AddVisibleToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :visible, :boolean, null: false, default: true
    end
  end
end
