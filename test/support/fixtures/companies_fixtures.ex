defmodule Merlin.CompaniesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Merlin.Companies` context.
  """

  @doc """
  Generate a offer.
  """
  def offer_fixture(attrs \\ %{}) do
    {:ok, offer} =
      attrs
      |> Enum.into(%{
        maximum_salary: 42,
        minimum_salary: 42,
        title: "some title",
        type: "some type"
      })
      |> Merlin.Companies.create_offer()

    offer
  end

  @doc """
  Generate a company.
  """
  def company_fixture(attrs \\ %{}) do
    {:ok, company} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Merlin.Companies.create_company()

    company
  end

  @doc """
  Generate a offer_type.
  """
  def offer_type_fixture(attrs \\ %{}) do
    {:ok, offer_type} =
      attrs
      |> Enum.into(%{
        color: "some color",
        name: "some name"
      })
      |> Merlin.Companies.create_offer_type()

    offer_type
  end

  @doc """
  Generate a offer_time.
  """
  def offer_time_fixture(attrs \\ %{}) do
    {:ok, offer_time} =
      attrs
      |> Enum.into(%{
        color: "some color",
        name: "some name"
      })
      |> Merlin.Companies.create_offer_time()

    offer_time
  end

  @doc """
  Generate a application.
  """
  def application_fixture(attrs \\ %{}) do
    {:ok, application} =
      attrs
      |> Enum.into(%{})
      |> Merlin.Companies.create_application()

    application
  end

  @doc """
  Generate a level.
  """
  def level_fixture(attrs \\ %{}) do
    {:ok, level} =
      attrs
      |> Enum.into(%{
        color: "some color",
        name: "some name"
      })
      |> Merlin.Companies.create_level()

    level
  end

  @doc """
  Generate a connection.
  """
  def connection_fixture(attrs \\ %{}) do
    {:ok, connection} =
      attrs
      |> Enum.into(%{})
      |> Merlin.Companies.create_connection()

    connection
  end
end
