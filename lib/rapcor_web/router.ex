defmodule RapcorWeb.Router do
  use RapcorWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/v1", RapcorWeb do
    pipe_through :api

    resources "/clinicians/tokens/", ClinicianTokenController
    resources "/clinicians", ClinicianController
  end
end
