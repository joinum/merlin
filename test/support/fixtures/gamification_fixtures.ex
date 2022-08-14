defmodule Merlin.GamificationFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Merlin.Gamification` context.
  """

  @doc """
  Generate a curriculum.
  """
  def curriculum_fixture(attrs \\ %{}) do
    {:ok, curriculum} =
      attrs
      |> Enum.into(%{
        summary: "some summary"
      })
      |> Merlin.Gamification.create_curriculum()

    curriculum
  end
end
