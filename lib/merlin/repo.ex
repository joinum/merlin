defmodule Merlin.Repo do
  use Ecto.Repo,
    otp_app: :merlin,
    adapter: Ecto.Adapters.Postgres
end
