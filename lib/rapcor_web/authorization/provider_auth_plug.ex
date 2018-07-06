defmodule Rapcor.Authorization.ProviderAuthPlug do
  import Plug.Conn

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Provider

  def init(_opts) do
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         %Provider{} = provider <- ProviderAccounts.get_provider_by_token(token)
    do
      assign(conn, :current_provider, provider)
    else
      _ ->
        conn
        |> send_resp(:unauthorized, "Unauthorized")
        |> halt
    end
  end
end
