defmodule Nice.Resolver.User do
  use Absinthe.Ecto, repo: Nice.Repo

  alias Nice.User
  alias Nice.Repo

  def find(_parent, %{id: id}, _info) do
    case Repo.get(User, id) do
      nil  -> {:error, "User id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def all(_parent, _args, _info) do
    {:ok, Repo.all(User) }
  end

  def create(_parent, attributes, _info) do
    IO.inspect attributes
    changeset = User.changeset(%User{}, attributes)
    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
