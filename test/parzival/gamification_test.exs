defmodule Merlin.GamificationTest do
  use Merlin.DataCase

  alias Merlin.Gamification

  describe "curriculums" do
    alias Merlin.Gamification.Curriculum

    import Merlin.GamificationFixtures

    @invalid_attrs %{summary: nil}

    test "list_curriculums/0 returns all curriculums" do
      curriculum = curriculum_fixture()
      assert Gamification.list_curriculums() == [curriculum]
    end

    test "get_curriculum!/1 returns the curriculum with given id" do
      curriculum = curriculum_fixture()
      assert Gamification.get_curriculum!(curriculum.id) == curriculum
    end

    test "create_curriculum/1 with valid data creates a curriculum" do
      valid_attrs = %{summary: "some summary"}

      assert {:ok, %Curriculum{} = curriculum} = Gamification.create_curriculum(valid_attrs)
      assert curriculum.summary == "some summary"
    end

    test "create_curriculum/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Gamification.create_curriculum(@invalid_attrs)
    end

    test "update_curriculum/2 with valid data updates the curriculum" do
      curriculum = curriculum_fixture()
      update_attrs = %{summary: "some updated summary"}

      assert {:ok, %Curriculum{} = curriculum} =
               Gamification.update_curriculum(curriculum, update_attrs)

      assert curriculum.summary == "some updated summary"
    end

    test "update_curriculum/2 with invalid data returns error changeset" do
      curriculum = curriculum_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Gamification.update_curriculum(curriculum, @invalid_attrs)

      assert curriculum == Gamification.get_curriculum!(curriculum.id)
    end

    test "delete_curriculum/1 deletes the curriculum" do
      curriculum = curriculum_fixture()
      assert {:ok, %Curriculum{}} = Gamification.delete_curriculum(curriculum)
      assert_raise Ecto.NoResultsError, fn -> Gamification.get_curriculum!(curriculum.id) end
    end

    test "change_curriculum/1 returns a curriculum changeset" do
      curriculum = curriculum_fixture()
      assert %Ecto.Changeset{} = Gamification.change_curriculum(curriculum)
    end
  end
end
