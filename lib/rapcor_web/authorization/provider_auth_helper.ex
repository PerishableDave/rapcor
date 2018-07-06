defmodule Rapcor.Authorization.ProviderAuthHelper do
  import Plug.Conn

  def current_provider(conn) do
    conn.assigns[:current_provider]
  end
end
