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

  scope "/", Nice do
    pipe_through :browser # Use the default browser stack

    # HTML Routes
    resources "/dogs", DogController
    resources "/pigs", PigController
    resources "/cows", CowController
    resources "/cats", CatController

    # Connect Routes
    get "/connect/dog_to_cats", DogToCatConnectController, :connect
    get "/connect/dog_to_cats/toggle", DogToCatConnectController, :toggle
    get "/connect/pig_to_cats", PigToCatConnectController, :connect
    get "/connect/pig_to_cats/toggle", PigToCatConnectController, :toggle
    get "/connect/cow_to_cats", CowToCatConnectController, :connect
    get "/connect/cow_to_cats/toggle", CowToCatConnectController, :toggle

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Nice do
  #   pipe_through :api
  # end
end
