defmodule Merlin.Gamification do
  @moduledoc """
  The Gamification context.
  """

  use Merlin.Context

  alias Ecto.Multi

  alias Merlin.Accounts.User
  alias Merlin.Gamification.Curriculum
  alias Merlin.Gamification.Curriculum.Education
  alias Merlin.Gamification.Curriculum.Experience
  alias Merlin.Gamification.Curriculum.Language
  alias Merlin.Gamification.Curriculum.Position
  alias Merlin.Gamification.Curriculum.Skill
  alias Merlin.Gamification.Curriculum.Volunteering

  @doc """
  Returns the list of curriculums.

  ## Examples

      iex> list_curriculums()
      [%Curriculum{}, ...]

  """
  def list_curriculums do
    Repo.all(Curriculum)
  end

  @doc """
  Gets a single curriculum.

  Raises `Ecto.NoResultsError` if the Curriculum does not exist.

  ## Examples

      iex> get_curriculum!(123)
      %Curriculum{}

      iex> get_curriculum!(456)
      ** (Ecto.NoResultsError)

  """
  def get_curriculum!(id), do: Repo.get!(Curriculum, id)

  def get_user_curriculum(%User{} = user, preloads \\ []) do
    curriculum =
      Repo.one(
        from c in Curriculum,
          where: c.user_id == ^user.id,
          preload: ^preloads
      )

    if is_nil(curriculum) do
      %{
        summary: nil,
        experiences: [],
        educations: [],
        volunteerings: [],
        skills: [],
        languages: [],
        user_id: user.id
      }
    else
      get_ordered_curriculum(curriculum, user)
    end
  end

  defp get_ordered_curriculum(curriculum, user) do
    %{
      summary:
        if curriculum.summary do
          curriculum.summary
        else
          nil
        end,
      experiences:
        if curriculum.experiences do
          Enum.map(curriculum.experiences, fn experience ->
            %{
              organization: experience.organization,
              positions:
                Enum.sort_by(
                  experience.positions,
                  &if is_nil(&1.finish) do
                    Date.utc_today()
                  else
                    &1.finish
                  end,
                  {:desc, Date}
                )
            }
          end)
        else
          []
        end,
      educations:
        if curriculum.educations do
          Enum.sort_by(curriculum.educations, & &1.finish, {:desc, Date})
        else
          []
        end,
      volunteerings:
        if curriculum.volunteerings do
          Enum.sort_by(curriculum.volunteerings, & &1.finish, {:desc, Date})
        else
          []
        end,
      skills:
        if curriculum.skills do
          curriculum.skills
        else
          []
        end,
      languages:
        if curriculum.languages do
          curriculum.languages
        else
          []
        end,
      user_id:
        if curriculum.user_id do
          curriculum.user_id
        else
          user.id
        end
    }
  end

  @doc """
  Creates a curriculum.

  ## Examples

      iex> create_curriculum(%{field: value})
      {:ok, %Curriculum{}}

      iex> create_curriculum(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_curriculum(attrs \\ %{}) do
    %Curriculum{}
    |> Curriculum.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a curriculum.

  ## Examples

      iex> update_curriculum(curriculum, %{field: new_value})
      {:ok, %Curriculum{}}

      iex> update_curriculum(curriculum, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_curriculum(%Curriculum{} = curriculum, attrs) do
    curriculum
    |> Curriculum.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a curriculum.

  ## Examples

      iex> delete_curriculum(curriculum)
      {:ok, %Curriculum{}}

      iex> delete_curriculum(curriculum)
      {:error, %Ecto.Changeset{}}

  """
  def delete_curriculum(%Curriculum{} = curriculum) do
    Repo.delete(curriculum)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking curriculum changes.

  ## Examples

      iex> change_curriculum(curriculum)
      %Ecto.Changeset{data: %Curriculum{}}

  """
  def change_curriculum(%Curriculum{} = curriculum, attrs \\ %{}) do
    Curriculum.changeset(curriculum, attrs)
  end


  def change_education(
        %Education{} = education,
        attrs \\ %{}
      ) do
    Education.changeset(education, attrs)
  end

  def change_experience(
        %Experience{} = experience,
        attrs \\ %{}
      ) do
    Experience.changeset(experience, attrs)
  end

  def change_language(
        %Language{} = language,
        attrs \\ %{}
      ) do
    Language.changeset(language, attrs)
  end

  def change_position(
        %Position{} = position,
        attrs \\ %{}
      ) do
    Position.changeset(position, attrs)
  end

  def change_skill(
        %Skill{} = skill,
        attrs \\ %{}
      ) do
    Skill.changeset(skill, attrs)
  end

  def change_volunteering(
        %Volunteering{} = volunteering,
        attrs \\ %{}
      ) do
    Volunteering.changeset(volunteering, attrs)
  end

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(Merlin.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

end
