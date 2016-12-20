defmodule Nice.Resolver.Dog do

  import Ecto.Changeset
  alias Nice.Dog
  alias Nice.Cat
  alias Nice.CatToDog
  alias Nice.Repo

  def find(_parent, %{id: id}, _info) do
    case Repo.get(Dog, id) do
      nil  -> {:error, "Dog id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def all(_parent, _args, _info) do
    {:ok, Repo.all(Dog) }
  end

  def create(_parent, %{cat_id: cid} = attributes, _info) do
    result = Repo.transaction fn ->
      cat = Repo.get_by!(Cat, id: cid)

      dog =
        %Dog{}
        |> Dog.changeset(attributes)
        |> Repo.insert!

      Repo.insert!(%CatToDog{cat: cat, dog: dog})

      dog
    end

    case result do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
