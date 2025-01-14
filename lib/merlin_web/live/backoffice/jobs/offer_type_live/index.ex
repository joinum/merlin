defmodule MerlinWeb.Backoffice.OfferTypeLive.Index do
  @moduledoc false
  use MerlinWeb, :live_view

  import MerlinWeb.Components.Pagination

  alias Merlin.Companies
  alias Merlin.Companies.OfferType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :jobs)
     |> assign(:params, params)
     |> assign(list_offer_types(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Type")
    |> assign(:offer_type, Companies.get_offer_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Type")
    |> assign(:offer_type, %OfferType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Types")
    |> assign(:offer_type, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    offer_time = Companies.get_offer_time!(id)
    {:ok, _} = Companies.delete_offer_time(offer_time)

    {:noreply, assign(socket, list_offer_types(%{}))}
  end

  @impl true
  def handle_event("search", %{"search" => %{"query" => query}}, socket) do
    params = build_search_map(socket.assigns.params, query)

    {:noreply, push_patch(socket, to: Routes.admin_offer_type_index_path(socket, :index, params))}
  end

  defp build_search_map(params, text) do
    filters =
      (params["filters"] || %{})
      |> Map.put("1", %{"field" => "search", "value" => text, "op" => "ilike_or"})

    Map.put(params, "filters", filters)
  end

  defp list_offer_types(params) do
    case Companies.list_offer_types(params) do
      {:ok, {offer_types, meta}} ->
        %{offer_types: offer_types, meta: meta}

      {:error, flop} ->
        %{offer_types: [], meta: flop}
    end
  end
end
