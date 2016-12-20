defmodule Nice.Schema do
  use Absinthe.Schema

  alias Nice.Resolver

  import_types Nice.Schema.Types

  query do
    field :user, :user do
      arg :id, non_null(:id)

      resolve &Resolver.User.find/3
    end

    field :users, list_of(:user) do
      resolve &Resolver.User.all/3
    end

    field :profile, :profile do
      arg :id, non_null(:id)

      resolve &Resolver.Profile.find/3
    end

    field :profiles, list_of(:profile) do
      resolve &Resolver.Profile.all/3
    end

    field :cat, :cat do
      arg :id, non_null(:id)

      resolve &Resolver.Cat.find/3
    end

    field :cats, list_of(:cat) do
      arg :limit, type: :integer
      resolve &Resolver.Cat.all/3
    end

    field :dog, :dog do
      arg :id, non_null(:id)

      resolve &Resolver.Dog.find/3
    end

    field :dogs, list_of(:dog) do
      resolve &Resolver.Dog.all/3
    end
  end

  mutation do

    field :create_cat, :cat do
      arg :name, non_null(:string)

      resolve &Resolver.Cat.create/3
    end

    field :create_dog, :dog do
      arg :name, non_null(:string)
      arg :cat_id, non_null(:id)

      resolve &Resolver.Dog.create/3
    end

    field :create_user, :user do
      arg :name, non_null(:string)

      resolve &Resolver.User.create/3
    end

    field :profile, :profile do
      arg :name, non_null(:string)
      arg :user_id, non_null(:id)

      resolve &Resolver.Profile.create/3
    end
  end
end
