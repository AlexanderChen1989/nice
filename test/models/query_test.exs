defmodule Nice.ConnectQuery do
  use ConnectQuery
end

defmodule Nice.OwnerToCatQueryTest do
  use Nice.ModelCase

  alias Nice.{Repo, Owner, Cat, OwnerToCat, ConnectQuery}

  describe "for a owner" do
    setup [:create_owner, :create_cat, :create_owner_to_cat]

    test "add a cat to owner", %{owner: owner} do
      cat_params = %{name: "Cat"}
      {:ok, cat} = ConnectQuery.owner_add_cat(owner.id, cat_params)
      assert cat.id
    end

    test "connect a cat to owner", %{owner: owner, cat: cat} do
      {:ok, cat} = ConnectQuery.owner_connect_cat(owner.id, cat.id)
      assert cat.id
    end

    test "delete a cat from owner", %{owner: owner, cat: cat} do
      {:ok, num} = ConnectQuery.owner_del_cat(owner.id, cat.id)
      assert num == 1
    end

    test "fetch o owner by id with cats preloaded", %{owner: owner, cat: cat} do
      {:ok, _owner} = ConnectQuery.owner_with_cats(owner.id)
      assert _owner.id == owner.id
      [_cat] = _owner.cats
      assert _cat.id == cat.id
    end

  end

  defp create_owner(_context) do
    {:ok, owner} =
      %Owner{name: "A Owner"}
      |> Repo.insert

    {:ok, owner: owner}
  end

  defp create_cat(_context) do
    {:ok, cat} =
      %Cat{name: "A Cat"}
      |> Repo.insert

    {:ok, cat: cat}
  end

  defp create_owner_to_cat(%{owner: owner, cat: cat}) do
    {:ok, owner_to_cat} =
      %OwnerToCat{owner: owner, cat: cat}
      |> Repo.insert
    {:ok, owner_to_cat: owner_to_cat}
  end
end








