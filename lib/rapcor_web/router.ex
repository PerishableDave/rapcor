defmodule RapcorWeb.Router do
  use RapcorWeb, :router

  alias Rapcor.Authorization.ClinicianAuthPlug

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/v1", RapcorWeb do
    pipe_through :api

    resources "/clinicians/tokens/", ClinicianTokenController
    
    get "/clinicians/current", ClinicianController, :current
    resources "/clinicians", ClinicianController

    resources "/experiences", ExperienceController
  end
end
