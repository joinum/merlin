defmodule MerlinWeb.App.CompanyLive.New do
  @moduledoc false
  use MerlinWeb, :live_view

  alias Merlin.Companies.Company

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :companies)
     |> assign(:page_title, "New Company")
     |> assign(:company, %Company{})}
  end
end
