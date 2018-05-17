defmodule RapcorWeb.Router do
  use RapcorWeb, :router


  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/v1", RapcorWeb do
    pipe_through :api

    resources "/clinicians/tokens/", ClinicianTokenController
    
    get "/clinicians/current", ClinicianController, :current
    put "/clinicians/current", ClinicianController, :update
    get "/clinicians/current/experiences", ClinicianExperienceController, :index
    post "/clinicians/current/experiences", ClinicianExperienceController, :create
    resources "/clinicians", ClinicianController, only: [:index, :create, :show]

    resources "/experiences", ExperienceController
  end
end
