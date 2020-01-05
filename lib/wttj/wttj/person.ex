defmodule Wttj.Wttj.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :name, :string
    field :toMeet, :boolean, default: false
    field :position, :integer, default: 0
    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:name, :toMeet, :position])
    |> validate_required([:name, :toMeet, :position])
  end
end
