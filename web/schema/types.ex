defmodule Nice.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :name, :string
    field :profiles, list_of(:profile)
  end

  object :profile do
    field :id, :id
    field :name, :string
  end

  object :cat do
    field :id, :id
    field :name, :string
    field :dogs, list_of(:dog)
    field :pet, :dog
    field :pets, list_of(:dog)
  end

  object :dog do
    field :id, :id
    field :name, :string
  end
end
