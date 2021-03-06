defmodule Dashex.Router do
  use Dashex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Dashex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/projects/new_from_readme", ProjectController, :new_from_readme
    post "/projects/new_from_readme", ProjectController, :create_from_readme

    resources "/projects", ProjectController do
      resources "/badges", BadgeController
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", Dashex do
  #   pipe_through :api
  # end
end
