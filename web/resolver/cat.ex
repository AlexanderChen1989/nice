defmodule Nice.Resolver.Cat do

  alias Nice.Cat
  alias Nice.Repo
  import Ecto.Query

  def find(_parent, %{id: id}, _info) do
    case Repo.get(Cat, id) do
      nil  -> {:error, "Cat id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def all(_parent, args, _info) do
    limit = Map.get(args, :limit)

    query =
      from c in Cat,
        preload: [:dogs, :pet, :pets],
        select: c,
        limit: ^limit

    {:ok, Repo.all(query) }
  end

  def create(_parent, attributes, _info) do
    IO.inspect attributes
    changeset = Cat.changeset(%Cat{}, attributes)
    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
