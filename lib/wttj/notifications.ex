defmodule Wttj.Notifications do
  use GenServer
  import Ecto.Query
  import Poison, only: [decode!: 1]
  alias Wttj.{Wttj.Person, Repo}


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
      "data" => _raw,
      "id" => _id,
      "table" => "persons",
      "type" => type
    } = decode!(payload)

    if type != "UPDATE" do
      persons = Person
      |> order_by(asc: :position)
      |> Repo.all()

      WttjWeb.Endpoint.broadcast!("person:lobby", "updatePerson", %{ persons: WttjWeb.PersonView.render("index.json", %{persons: persons}) })
    end

    {:noreply, {pid, ref, channel, data}}
  end
end
