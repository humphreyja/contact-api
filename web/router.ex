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
    plug :cors
    plug :accepts, ["json"]
  end

  scope "/", ContactApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ContactApi do
    pipe_through :api
    resources "/users", UserController
    options "/users", UserController, :options
    options "/users/:id", UserController, :options
  end

  def cors(conn, _opts) do
    conn
      |> put_resp_header("Access-Control-Allow-Origin", "*")
      |> put_resp_header("Access-Control-Allow-Headers", "Content-Type")
      |> put_resp_header("Access-Control-Allow-Methods", "GET, PUT, PATCH, OPTIONS, DELETE, POST")
  end
end
