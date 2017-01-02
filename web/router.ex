defmodule Nice.Router do
  use Nice.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    get "/graphiql", Absinthe.Plug.GraphiQL, schema: Nice.Schema
    post "/graphiql", Absinthe.Plug.GraphiQL, schema: Nice.Schema
    forward "/graphql", Absinthe.Plug, schema: Nice.Schema
  end

  scope "/", Nice do
    pipe_through :browser # Use the default browser stack

    resources "/dogs", DogController
    resources "/pigs", PigController
    resources "/owners", OwnerController
    resources "/cats", CatController
    resources "/cows", CowController
    resources "/pigs/:pig_id/cows", CowController, param: "cow_id"
    get "/connect/owner_to_cats", OwnerToCatConnectController, :connect
    get "/connect/owner_to_cats/toggle", OwnerToCatConnectController, :toggle
    get "/connect/pig_to_cows", PigToCowConnectController, :connect
    get "/connect/pig_to_cows/toggle", PigToCowConnectController, :toggle
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Nice do
  #   pipe_through :api
  # end
end
