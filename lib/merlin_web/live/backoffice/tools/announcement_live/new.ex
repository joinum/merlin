defmodule MerlinWeb.Backoffice.AnnouncementLive.New do
  @moduledoc false
  use MerlinWeb, :live_view

  alias Merlin.Tools.Announcement

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :announcement)
     |> assign(:page_title, "New Announcement")
     |> assign(:announcement, %Announcement{})}
  end
end
