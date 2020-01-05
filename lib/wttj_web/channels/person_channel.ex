defmodule WttjWeb.PersonChannel do
  use WttjWeb, :channel
  import Ecto.Query
  alias Wttj.{Repo, Wttj.Person}

  def join("person:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info(:after_join, socket) do
      broadcast_update(socket)
      {:noreply, socket}
  end

  defp broadcast_update(socket) do
    persons = Person
    |> order_by(asc: :position)
    |> Repo.all()

    broadcast!(socket, "updatePersons", %{persons: WttjWeb.PersonView.render("index.json", %{persons: persons})})
  end

  def handle_in("updatePersons", %{"persons" => persons}, socket) do
    Enum.each(persons, fn(person) ->
      tmp = Person
      |> Repo.get(person["id"])

      Person.changeset(tmp, person)
      |> Repo.update
    end)

    broadcast_update(socket)

    {:noreply, socket}
  end

  def handle_in("deletePerson", %{"id" => id}, socket) do
    Repo.get!(Person, id)
    |> Repo.delete

    broadcast_update(socket)

    {:noreply, socket}
  end

  def handle_in("createPerson", %{"name" => name}, socket) do
    Repo.insert(%Person{name: name})

    broadcast_update(socket)

    {:noreply, socket}
  end


  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
