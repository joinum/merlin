defmodule ParzivalWeb.AnnouncementLive.Edit do
  @moduledoc false
  use ParzivalWeb, :live_view

  alias Parzival.Tools

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :announcement)
     |> assign(:page_title, "Edit Announcement")
     |> assign(:announcement, Tools.get_announcement!(id))}
  end
end
