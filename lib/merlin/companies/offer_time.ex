defmodule Merlin.Companies.OfferTime do
  @moduledoc """
  A time of job offer.
  """
  use Merlin.Schema

  alias Merlin.Companies.Offer

  @colors ~w(gray red orange amber yellow lime green emerald teal cyan sky blue indigo violet purple fuchsia pink rose)a

  @derive {
    Flop.Schema,
    filterable: [:search],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order_by: [:name],
    default_order_directions: [:asc]
  }

  schema "offer_times" do
    field :name, :string
    field :color, Ecto.Enum, values: @colors

    has_many :offers, Offer

    timestamps()
  end

  @doc false
  def changeset(offer_time, attrs) do
    offer_time
    |> cast(attrs, [:name, :color])
    |> validate_required([:name, :color])
  end
end
