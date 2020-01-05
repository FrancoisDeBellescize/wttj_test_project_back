defmodule Wttj.Repo.Migrations.AddPositionToPerson do
  use Ecto.Migration

  def change do
    alter table("persons") do
      add :position, :integer, default: 0, null: false
    end
  end
end
