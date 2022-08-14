defmodule Merlin.Repo.Seeds.Tools do
  import Ecto.Query

  alias Merlin.Repo

  alias Merlin.Accounts.User

  alias Merlin.Tools.Announcement

  def run do
    seed_announcements()
  end

  def seed_announcements do
    admins = Repo.all(where(User, role: :admin))

    case Repo.all(Announcement) do
      [] ->
        for _n <- 1..40 do
          Announcement.changeset(
            %Announcement{},
            %{
              title: Faker.Lorem.sentence(3..5),
              text: Faker.Lorem.sentence(200..400),
              author_id: Enum.random(admins).id
            }
          )
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end
end

Merlin.Repo.Seeds.Tools.run()
