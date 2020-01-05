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

defimpl Poison.Encoder, for: Wttj.Wttj.Person do
  def encode(%{__struct__: _} = struct, options) do
    map = struct
          |> Map.from_struct
          |> Map.drop([:__meta__, :__struct__])
    Poison.Encoder.Map.encode(map, options)
  end
end
