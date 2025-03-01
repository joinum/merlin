defmodule MerlinWeb.App.ProfileLive.Show do
  @moduledoc false
  use MerlinWeb, :live_view

  import MerlinWeb.Components.Buttons
  import MerlinWeb.Components.Curriculum

  alias Merlin.Accounts
  alias Merlin.Companies
  alias Merlin.Gamification
  alias Merlin.Uploaders

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"qr" => qr}, _url, socket) do
    user = Accounts.get_user_by_qr(qr)

    if socket.assigns.current_user.role == :recruiter && user.role == :attendee do
      company = Companies.get_company!(socket.assigns.current_user.company_id)

      case Companies.create_connection(company, user) do
        {:ok, _connection} ->
          {:noreply,
           socket
           |> put_flash(:success, gettext("New Connection!"))}

        {:error, _error} ->
          {:noreply, socket}
      end
    end

    if user == nil do
      {:noreply,
       socket
       |> push_redirect(to: Routes.user_registration_path(socket, :new, qr))}
    else
      {:noreply,
       socket
       |> push_redirect(to: Routes.profile_edit_path(socket, :edit, user.id))}
    end
  end

  @impl true
  def handle_params(%{"id" => id} = params, _url, socket) do
    user = Accounts.get_user!(id, [:company])

    if socket.assigns.current_user.role == :recruiter && user.role == :attendee do
      company = Companies.get_company!(socket.assigns.current_user.company_id)

      case Companies.create_connection(company, user) do
        {:ok, _connection} ->
          {:noreply,
           socket
           |> put_flash(:success, gettext("New Connection!"))}

        {:error, _error} ->
          {:noreply, socket}
      end
    end

    {:noreply,
     socket
     |> assign(:current_page, :profile)
     |> assign(:current_tab, user.role)
     |> assign(:page_title, "Show User")
     |> assign(:params, params)
     |> assign(:user, user)
     |> handle_user_role(user)
     |> handle_current_user_role(socket.assigns.current_user)}
  end

  defp handle_user_role(socket, user) do
    case user.role do
      :recruiter ->
        socket
        |> assign(:recruiters, list_recruiters(user.company.id))

      :attendee ->
        socket
        |> assign(:curriculum, Gamification.get_user_curriculum(user))

      _ ->
        socket
    end
  end

  defp handle_current_user_role(socket, user) do
    case user.role do
      :staff ->
        socket
        |> assign(
          :connections,
          Companies.list_connections(
            where: [user_id: socket.assigns.user.id],
            preloads: :company
          )
        )

      :admin ->
        socket
        |> assign(
          :connections,
          Companies.list_connections(
            where: [user_id: socket.assigns.user.id],
            preloads: :company
          )
        )

      _ ->
        socket
    end
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    {:ok, _} = Accounts.delete_user(socket.assigns.user)

    {:noreply,
     push_redirect(socket,
       to:
         Routes.admin_user_index_path(socket, :index, %{
           "filters" => %{"0" => %{"field" => "role", "value" => socket.assigns.user.role}}
         })
     )}
  end

  defp list_recruiters(id) do
    Accounts.list_users(
      preloads: :company,
      where: [company_id: id]
    )
  end
end
