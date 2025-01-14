defmodule MerlinWeb.App.ConnectionLive.Index do
  @moduledoc false
  use MerlinWeb, :live_view

  alias Merlin.Companies

  import MerlinWeb.Components.Pagination

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :connections)
     |> assign(:params, params)
     |> assign(:page_title, "Listing Connections")
     |> assign(list_connections(params, socket))}
  end

  defp list_connections(params, socket) do
    case Companies.list_connections(
           params,
           where: [
             company_id: socket.assigns.current_user.company_id
           ],
           preloads: :user
         ) do
      {:ok, {connections, meta}} ->
        %{connections: connections, meta: meta}

      {:error, flop} ->
        %{connections: [], meta: flop}
    end
  end
end
