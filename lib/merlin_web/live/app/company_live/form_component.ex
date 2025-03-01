defmodule MerlinWeb.App.CompanyLive.FormComponent do
  @moduledoc false
  use MerlinWeb, :live_component

  alias Merlin.Companies

  @extensions_whitelist ~w(.jpg .jpeg .gif .png)

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> allow_upload(:picture, accept: @extensions_whitelist, max_entries: 1)}
  end

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Companies.change_company(company)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(list_levels(assigns))}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Companies.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Companies.update_company(
           socket.assigns.company,
           company_params,
           &consume_picture_data(socket, &1)
         ) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:success, "Company updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Companies.create_company(company_params, &consume_picture_data(socket, &1)) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:success, "Company created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp consume_picture_data(socket, company) do
    consume_uploaded_entries(socket, :picture, fn %{path: path}, entry ->
      Companies.update_company_picture(company, %{
        "picture" => %Plug.Upload{
          content_type: entry.client_type,
          filename: entry.client_name,
          path: path
        }
      })
    end)
    |> case do
      [{:ok, company}] ->
        {:ok, company}

      _errors ->
        {:ok, company}
    end
  end

  defp list_levels(params) do
    case Companies.list_levels(params) do
      {:ok, {levels, _meta}} ->
        %{levels: levels}

      {:error, _flop} ->
        %{levels: []}
    end
  end
end
