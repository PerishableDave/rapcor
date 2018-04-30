defmodule Rapcor.Authorization.ClinicianAuthHelper do
  import Plug.Conn

  def current_clinician(conn) do
    conn.assigns[:current_clinician]
  end
end
