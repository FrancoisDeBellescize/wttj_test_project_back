defmodule WttjWeb.PersonView do
  use WttjWeb, :view

  def render("index.json", %{persons: persons}) do
    render_many(persons, WttjWeb.PersonView, "person.json")
  end

  def render("person.json", %{person: person}) do
    %{
      id: person.id,
      name: person.name,
      toMeet: person.toMeet,
      position: person.position
    }
  end
end
