defmodule Wttj.Wttj.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :name, :string
    field :toMeet, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :toMeet])
    |> validate_required([:name, :toMeet])
  end
end
