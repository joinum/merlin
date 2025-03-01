defmodule MerlinWeb.App.AnnouncementLive.Index do
  @moduledoc false
  use MerlinWeb, :live_view

  import MerlinWeb.Components.Pagination

  alias Merlin.Tools

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, list_announcements(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :announcements)
     |> assign(:params, params)
     |> assign(list_announcements(params))}
  end

  defp list_announcements(params) do
    case Tools.list_announcements(params, preloads: [:author]) do
      {:ok, {announcements, meta}} ->
        %{announcements: announcements, meta: meta}

      {:error, flop} ->
        %{announcements: [], meta: flop}
    end
  end
end
