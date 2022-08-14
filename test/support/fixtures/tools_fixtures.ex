defmodule Merlin.ToolsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Merlin.Tools` context.
  """

  @doc """
  Generate a announcement.
  """
  def announcement_fixture(attrs \\ %{}) do
    {:ok, announcement} =
      attrs
      |> Enum.into(%{
        text: "some text",
        title: "some title"
      })
      |> Merlin.Tools.create_announcement()

    announcement
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> Merlin.Tools.create_post()

    post
  end
end
