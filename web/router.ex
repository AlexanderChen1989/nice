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
    resources "/categories", CategoryController
    resources "/products", ProductController
  end

  # Other scopes may use custom stacks.
  scope "/api", Nice do
    pipe_through :api
    resources "/categories", API.CategoryController, except: [:new, :edit]
    resources "/products", API.ProductController, except: [:new, :edit]
  end
end
