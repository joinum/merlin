defmodule MerlinWeb.App.CompanyLive.Edit do
  @moduledoc false
  use MerlinWeb, :live_view

  alias Merlin.Companies

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :companies)
     |> assign(:page_title, "Edit Company")
     |> assign(:company, Companies.get_company!(id))}
  end
end
