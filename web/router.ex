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

    # HTML Routes
    resources "/users", UserController
    resources "/profiles", ProfileController
    resources "/user_to_profiles", UserToProfileController

    # Connect Routes
    get "/connect/user_to_profiles", UserToProfileConnectController, :connect
    get "/connect/user_to_profiles/toggle", UserToProfileConnectController, :toggle

  end

  # Other scopes may use custom stacks.
  scope "/api", Nice do
    pipe_through :api

    # API Routes
    resources "/users", API.UserController, except: [:new, :edit]
    resources "/profiles", API.ProfileController, except: [:new, :edit]
    resources "/user_to_profiles", API.UserToProfileController, except: [:new, :edit]


  end
end
