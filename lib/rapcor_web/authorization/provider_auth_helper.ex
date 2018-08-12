defmodule Rapcor.Authorization.ProviderAuthHelper do
  def current_provider(conn) do
    conn.assigns[:current_provider]
  end
end
