defmodule Nice.ConnectQuery do
  alias Nice.{Repo, Owner, Cat, OwnerToCat}
  alias Ecto.Multi
  import Ecto.Query

  def owner_add_cat(owner_id, cat_params) do
    Multi.new
    |> Multi.run(:owner, &get_owner(&1, owner_id))
    |> Multi.run(:cat, &create_cat(&1, cat_params))
    |> Multi.run(:owner_to_cat, &create_owner_to_cat(&1))
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, changes.cat}
      {:error, :cat, changeset, _} -> {:error, changeset.errors}
      {:error, :owner_to_cat, changeset, _} -> {:error, changeset.errors}
      {:error, _, reason, _} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  defp create_cat(%{owner: owner}, cat_params) do
    %Cat{}
    |> Cat.changeset(cat_params)
    |> Repo.insert
  end

  defp create_owner_to_cat(%{cat: cat, owner: owner}) do
    %OwnerToCat{cat: cat, owner: owner}
    |> Repo.insert
  end

  defp get_owner(_changes, owner_id) do
    case Repo.get(Owner, owner_id) do
      nil -> {:error, "Owner not found"}
      owner -> {:ok, owner}
    end
  end

  defp get_cat(_changes, cat_id) do
    case Repo.get(Cat, cat_id) do
      nil -> {:error, "Cat not found"}
      cat -> {:ok, cat}
    end
  end


  def owner_connect_cat(owner_id, cat_id) do
    Multi.new
    |> Multi.run(:owner, &get_owner(&1, owner_id))
    |> Multi.run(:cat, &get_cat(&1, cat_id))
    |> Multi.run(:owner_to_cat, &create_owner_to_cat(&1))
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, changes.cat}
      {:error, :cat, changeset, _} -> {:error, changeset.errors}
      {:error, :owner_to_cat, changeset, _} -> {:error, changeset.errors}
      {:error, _, reason, _} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  def owner_del_cat(owner_id, cat_id) do
    query =
      from owner_to_cat in OwnerToCat,
        where: [owner_id: ^owner_id, cat_id: ^cat_id]

    {num, _} =  Repo.delete_all(query)
    {:ok, num}
  end

  def owner_with_cats(owner_id) do
    query =
      from owner in Owner,
        where: [id: ^owner_id],
        preload: :cats

    case Repo.one(query) do
      nil -> {:error, "Owner not found"}
      owner -> {:ok, owner}
    end
  end
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








