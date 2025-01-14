defmodule Merlin.Repo.Seeds.Accounts do
  alias Merlin.Repo

  alias Merlin.Accounts.QRCode
  alias Merlin.Accounts.User
  alias Merlin.Companies.Company
  alias Merlin.Companies.Offer

  @attendees File.read!("priv/fake/attendees.txt") |> String.split("\n")
  @recruiters File.read!("priv/fake/recruiters.txt") |> String.split("\n")
  @staffs File.read!("priv/fake/staffs.txt") |> String.split("\n")
  @courses File.read!("priv/fake/uminho_courses.txt") |> String.split("\n")

  def run do
    seed_qrs(100)
    seed_users()
  end

  def seed_qrs(n) do
    case Repo.all(QRCode) do
      [] ->
        for _i <- 1..n do
          uuid = %{uuid: Ecto.UUID.generate()}

          %QRCode{}
          |> QRCode.changeset(uuid)
          |> Repo.insert()
        end

      _ ->
        Mix.shell().error("Found qr codes, aborting seeding qr codes.")
    end
  end

  def seed_users do
    case Repo.all(User) do
      [] ->
        for attendee <- @attendees do
          email =
            String.downcase(attendee)
            |> String.normalize(:nfd)
            |> String.replace(~r/[^A-z\s]/u, "")
            |> String.replace(" ", "_")

          %{
            name: attendee,
            email: email <> "@mail.pt",
            password: "Password1234",
            role: :attendee,
            course: Enum.random(@courses),
            cycle: Enum.random([:Bachelors, :Masters, :Phd]),
            cellphone:
              "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}",
            website: email <> "." <> Faker.Internet.domain_suffix(),
            linkedin: email,
            github: email,
            twitter: email,
            balance: Enum.random(1000..9999),
            exp: Enum.random(100..3000)
          }
          |> insert_user()
        end

        companies = Repo.all(Company)

        for recruiter <- @recruiters do
          email =
            String.downcase(recruiter)
            |> String.normalize(:nfd)
            |> String.replace(~r/[^A-z\s]/u, "")
            |> String.replace(" ", "_")

          %{
            name: recruiter,
            email: email <> "@mail.pt",
            password: "Password1234",
            role: :recruiter,
            cellphone:
              "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}",
            website: email <> "." <> Faker.Internet.domain_suffix(),
            linkedin: email,
            github: email,
            twitter: email,
            company_id: Enum.random(companies).id
          }
          |> insert_user()
        end

        for staff <- @staffs do
          email =
            String.downcase(staff)
            |> String.normalize(:nfd)
            |> String.replace(~r/[^A-z\s]/u, "")
            |> String.replace(" ", "_")

          %{
            name: staff,
            email: email <> "@mail.pt",
            password: "Password1234",
            role: :staff,
            cellphone:
              "+351 9#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}",
            website: email <> "." <> Faker.Internet.domain_suffix(),
            linkedin: email,
            github: email,
            twitter: email
          }
          |> insert_user()
        end

        [
          %{
            name: "Filipe Felício",
            email: "felicio@cesium.pt",
            password: "Password1234",
            role: :admin
          },
          %{
            name: "Luís Araújo",
            email: "laraujo@cesium.pt",
            password: "Password1234",
            role: :admin
          },
          %{
            name: "David Machado",
            email: "david@necc.pt",
            password: "Password1234",
            role: :admin
          },
          %{
            name: "Maria João Portela",
            email: "mj@nefum.pt",
            password: "Password1234",
            role: :admin
          }
        ]
        |> Enum.each(&insert_user/1)

      _ ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  defp insert_user(data) do
    %User{}
    |> User.registration_changeset(data)
    |> Repo.insert!()
  end
end

Merlin.Repo.Seeds.Accounts.run()
