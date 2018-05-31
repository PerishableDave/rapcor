defmodule RapcorWeb.Router do
  use RapcorWeb, :router


  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/v1", RapcorWeb do
    pipe_through :api

    resources "/clinicians/tokens/", ClinicianTokenController
    
    get "/clinicians/current", ClinicianController, :current, as: :current_clinician
    put "/clinicians/current", ClinicianController, :update, as: :current_clinician
   
    scope "/clinicians/current", as: :current_clinician do
      resources "/experiences", ClinicianExperienceController, only: [:index, :create], as: :experience
      resources "/documents", DocumentController
    end

    resources "/clinicians", ClinicianController, only: [:index, :create, :show]

    resources "/experiences", ExperienceController
  end
end
