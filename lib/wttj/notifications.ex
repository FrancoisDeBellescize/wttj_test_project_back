defmodule Wttj.Notifications do
  use GenServer
  alias Wttj.{Wttj.Person, Repo}

  import Poison, only: [decode!: 1]

  def start_link(channel) do
    GenServer.start_link(__MODULE__, channel)
  end

  def init(channel) do
    {:ok, pid} = Application.get_env(:wttj, Wttj.Repo)
      |> Postgrex.Notifications.start_link()
    ref = Postgrex.Notifications.listen!(pid, channel)

    data = Person |> Repo.all

    {:ok, {pid, ref, channel, data}}
  end

  def handle_info({:notification, pid, ref, "persons_changes", payload}, {pid, ref, channel, data}) do
    %{
      "data" => raw,
      "id" => id,
      "table" => "persons",
      "type" => type
    } = decode!(payload)
    row = for {k, v} <- raw, into: %{}, do: {String.to_atom(k), v}

    updated_data = case type do
      "UPDATE" -> Enum.map(data, fn x -> if x.id === id do Map.merge(x, row) else x end end)
      "INSERT" -> data ++ [struct(Person, row)]
      "DELETE" -> Enum.filter(data,  &(&1.id !== id))
    end

    # Sending data to all clients
    WttjWeb.Endpoint.broadcast!("person:lobby", "updated_data", %{ persons: WttjWeb.PersonView.render("index.json", %{persons: updated_data}) })

    {:noreply, {pid, ref, channel, updated_data}}
  end
end
