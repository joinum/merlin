defmodule Merlin.Repo.Seeds.Gamification do
  import Ecto.Query

  alias Merlin.Repo
  alias Merlin.Accounts.User
  alias Merlin.Gamification
  alias Merlin.Gamification.Curriculum

  @education_titles File.read!("priv/fake/uminho_courses.txt") |> String.split("\n")
  @languages File.read!("priv/fake/languages.txt") |> String.split("\n")
  @universities File.read!("priv/fake/universities.txt") |> String.split("\n")

  def run do
    seed_curriculums()
  end

  def seed_curriculums do
    case Repo.all(Curriculum) do
      [] ->
        attendees =
          User
          |> where(role: :attendee)
          |> Repo.all()

        education_titles = Enum.shuffle(@education_titles)
        laguanges = Enum.shuffle(@languages)
        universities = Enum.shuffle(@universities)

        for attendee <- attendees do
          Curriculum.changeset(%Curriculum{}, %{
            summary: Faker.Lorem.sentence(20..40),
            user_id: attendee.id,
            experiences:
              Enum.reduce(
                List.duplicate(:experiences, Enum.random(1..3)),
                [],
                fn _n, acc ->
                  [
                    %{
                      organization: Faker.Company.name(),
                      positions:
                        Enum.reduce(
                          List.duplicate(:position, Enum.random(1..4)),
                          [],
                          fn _next, acc ->
                            [
                              %{
                                title: Faker.Person.title(),
                                start: Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                                finish:
                                  Enum.random([
                                    Faker.DateTime.between(
                                      ~D[2021-04-11],
                                      Date.utc_today()
                                    ),
                                    nil
                                  ])
                              }
                              | acc
                            ]
                          end
                        )
                    }
                    | acc
                  ]
                end
              ),
            educations:
              Enum.reduce(
                List.duplicate(:educations, Enum.random(1..2)),
                [],
                fn _n, acc ->
                  [
                    %{
                      institution: Enum.random(universities),
                      course: Enum.random(education_titles),
                      start: Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                      finish:
                        Faker.DateTime.between(
                          ~D[2021-04-11],
                          Date.utc_today()
                        )
                    }
                    | acc
                  ]
                end
              ),
            volunteerings:
              Enum.reduce(
                List.duplicate(:voluntary, Enum.random(1..2)),
                [],
                fn _n, acc ->
                  [
                    %{
                      institution: Faker.Company.name(),
                      position: Faker.Person.title(),
                      start: Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                      finish:
                        Faker.DateTime.between(
                          ~D[2021-04-11],
                          Date.utc_today()
                        )
                    }
                    | acc
                  ]
                end
              ),
            skills:
              Enum.reduce(
                List.duplicate(:skill, Enum.random(6..12)),
                [],
                fn _n, acc ->
                  [
                    %{
                      name: Faker.Beer.En.brand()
                    }
                    | acc
                  ]
                end
              ),
            languages:
              Enum.reduce(
                List.duplicate(:skill, Enum.random(2..4)),
                [],
                fn _n, acc ->
                  [
                    %{
                      idiom: Enum.random(laguanges),
                      proficiency: Enum.random([:Native, :Fluent, :Intermediary, :Basic])
                    }
                    | acc
                  ]
                end
              )
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found Curriculums, aborting seeding curriculums.")
    end
  end

end

Merlin.Repo.Seeds.Gamification.run()
