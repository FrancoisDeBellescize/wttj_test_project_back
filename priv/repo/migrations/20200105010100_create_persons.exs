defmodule Wttj.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string
      add :toMeet, :boolean, default: false, null: false

      timestamps()
    end

  end
end
