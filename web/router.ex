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

    get "/", PageController, :index
    resources "/dogs", DogController
    resources "/categories", CategoryController
    resources "/products", ProductController
    resources "/good_groups", GoodGroupController
    resources "/users", UserController
    resources "/profiles", ProfileController
    resources "/user_to_profiles", UserToProfilesController
    get "/connect/user_to_profiles", UserToProfilesConnectController, :connect
    get "/connect/user_to_profiles/toggle", UserToProfilesConnectController, :toggle

    resources "/cats", CatController
    resources "/rats", RatController
    resources "/cat_to_rats", CatToRatController
    get "/connect/cat_to_rats", CatToRatConnectController, :connect
    get "/connect/cat_to_rats/toggle", CatToRatConnectController, :toggle

  end

  # Other scopes may use custom stacks.
  scope "/api", Nice do
    pipe_through :api

    resources "/user_to_profiles", API.UserToProfilesController, except: [:new, :edit]
    resources "/categories", API.CategoryController, except: [:new, :edit]
    resources "/products", API.ProductController, except: [:new, :edit]
    resources "/good_groups", API.GoodGroupController, except: [:new, :edit]
    resources "/users", API.UserController, except: [:new, :edit]
    resources "/profiles", API.ProfileController, except: [:new, :edit]

    resources "/cats", API.CatController, except: [:new, :edit]
    resources "/rats", API.RatController, except: [:new, :edit]
    resources "/cat_to_rats", API.CatToRatController, except: [:new, :edit]

  end
end
