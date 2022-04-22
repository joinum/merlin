defmodule Parzival.StoreTest do
  use Parzival.DataCase

  alias Parzival.Store

  describe "products" do
    alias Parzival.Store.Product

    import Parzival.StoreFixtures

    @invalid_attrs %{description: nil, max_per_user: nil, name: nil, price: nil, stock: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Store.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Store.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{description: "some description", max_per_user: 42, name: "some name", price: 42, stock: 42}

      assert {:ok, %Product{} = product} = Store.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.max_per_user == 42
      assert product.name == "some name"
      assert product.price == 42
      assert product.stock == 42
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{description: "some updated description", max_per_user: 43, name: "some updated name", price: 43, stock: 43}

      assert {:ok, %Product{} = product} = Store.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.max_per_user == 43
      assert product.name == "some updated name"
      assert product.price == 43
      assert product.stock == 43
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_product(product, @invalid_attrs)
      assert product == Store.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Store.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Store.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Store.change_product(product)
    end
  end

  describe "prizes" do
    alias Parzival.Store.Prize

    import Parzival.StoreFixtures

    @invalid_attrs %{quantity: nil, redeemed: nil}

    test "list_prizes/0 returns all prizes" do
      prize = prize_fixture()
      assert Store.list_prizes() == [prize]
    end

    test "get_prize!/1 returns the prize with given id" do
      prize = prize_fixture()
      assert Store.get_prize!(prize.id) == prize
    end

    test "create_prize/1 with valid data creates a prize" do
      valid_attrs = %{quantity: 42, redeemed: 42}

      assert {:ok, %Prize{} = prize} = Store.create_prize(valid_attrs)
      assert prize.quantity == 42
      assert prize.redeemed == 42
    end

    test "create_prize/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Store.create_prize(@invalid_attrs)
    end

    test "update_prize/2 with valid data updates the prize" do
      prize = prize_fixture()
      update_attrs = %{quantity: 43, redeemed: 43}

      assert {:ok, %Prize{} = prize} = Store.update_prize(prize, update_attrs)
      assert prize.quantity == 43
      assert prize.redeemed == 43
    end

    test "update_prize/2 with invalid data returns error changeset" do
      prize = prize_fixture()
      assert {:error, %Ecto.Changeset{}} = Store.update_prize(prize, @invalid_attrs)
      assert prize == Store.get_prize!(prize.id)
    end

    test "delete_prize/1 deletes the prize" do
      prize = prize_fixture()
      assert {:ok, %Prize{}} = Store.delete_prize(prize)
      assert_raise Ecto.NoResultsError, fn -> Store.get_prize!(prize.id) end
    end

    test "change_prize/1 returns a prize changeset" do
      prize = prize_fixture()
      assert %Ecto.Changeset{} = Store.change_prize(prize)
    end
  end
end
