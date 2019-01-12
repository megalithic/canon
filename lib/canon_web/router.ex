defmodule CanonWeb.Router do
  use CanonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CanonWeb do
    pipe_through :api
  end
end
