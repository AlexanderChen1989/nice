defmodule Nice.Resolver.Profile do

  alias Nice.Profile
  alias Nice.Repo

  def find(_parent, %{id: id}, _info) do
    case Repo.get(Profile, id) do
      nil  -> {:error, "Profile id #{id} not found"}
      user -> {:ok, user}
    end
  end

  def all(_parent, _args, _info) do
    {:ok, Repo.all(Profile) }
  end

  def create(_parent, attributes, _info) do
    IO.inspect attributes
    changeset = Profile.changeset(%Profile{}, attributes)
    case Repo.insert(changeset) do
      {:ok, user} -> {:ok, user}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
