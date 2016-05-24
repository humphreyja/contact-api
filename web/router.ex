defmodule ContactApi.Router do
  use ContactApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug ContactApi.AuthorizeApi
  end

  pipeline :auth_api do
    plug ContactApi.Authentication
  end

  scope "/", ContactApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ContactApi do
    pipe_through :api

    resources "/users", UserController
    resources "/sessions", SessionController, only: [:create]

    scope "/user" do
      pipe_through :auth_api

      resources "/contacts", ContactController
      resources "/smarttext", SmartTextController, only: [:create]
    end
  end
end
