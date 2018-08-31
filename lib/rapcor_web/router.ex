defmodule RapcorWeb.Router do
  use RapcorWeb, :router


  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/v1", RapcorWeb do
    pipe_through :api

    resources "/clinicians/tokens/", ClinicianTokenController, only: [:create, :delete]

    get "/clinicians/request-bids/:slug", ClinicianRequestBidController, :show
    post "/clinicians/request-bids/:slug/accept", ClinicianRequestBidController, :accept

    get "/clinicians/current", ClinicianController, :current, as: :current_clinician
    put "/clinicians/current", ClinicianController, :update, as: :current_clinician
   
    scope "/clinicians/current", as: :current_clinician do
      resources "/experiences", ClinicianExperienceController, only: [:index, :create], as: :experience
      resources "/documents", DocumentController
    end

    resources "/clinicians", ClinicianController, only: [:index, :create, :show]

    resources "/experiences", ExperienceController

    resources "/providers/tokens/", ProviderTokenController, only: [:create, :delete]

    resources "/providers", ProviderController, only: [:create]
    
    get "/providers/current", ProviderController, :show, as: :current_provider
    put "/providers/current", ProviderController, :update, as: :current_provider

    scope "/providers/current", as: :current_provider do
      resources "/requests", ProviderRequestController, only: [:index, :create, :update, :show], as: :request
    end
  end
end
