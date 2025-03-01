defmodule Merlin.Companies.Connection do
  @moduledoc """
  A connection between a company and a attendee.
  """
  use Merlin.Schema

  alias Merlin.Accounts.User
  alias Merlin.Companies.Company

  @required_fields ~w(user_id company_id)a

  @optional_fields []

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [],
    compound_fields: [search: []],
    default_order_by: [],
    default_order_directions: [:asc]
  }

  schema "connections" do
    belongs_to :company, Company
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:company_id, :user_id])
  end
end
