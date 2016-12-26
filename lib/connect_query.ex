defmodule ConnectQuery do
  defmacro __using__(_) do
    for {from, :many_to_many, to} <- Models.relations do
      from_s = Macro.underscore(from)
      to_s = Macro.underscore(to)
      from = "Elixir.#{from}" |> String.to_atom
      to = "Elixir.#{to}" |> String.to_atom
      from_to_to = "Elixir.#{from}To#{to}" |> String.to_atom
      from_to_to_s = "#{from_s}_to_#{to_s}"

      quote do
        alias Nice.ConnectQuery
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
    end
  end
end
