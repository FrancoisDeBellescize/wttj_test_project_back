defmodule WttjWeb.PersonChannel do
  use WttjWeb, :channel
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
    persons = Repo.all(Person)

    # Sending data to all clients
    broadcast!(socket, "update_persons", %{persons: WttjWeb.PersonView.render("index.json", %{persons: persons})})
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
