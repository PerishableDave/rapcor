defmodule Rapcor.Authorization.ClinicianAuthHelper do
  def current_clinician(conn) do
    conn.assigns[:current_clinician]
  end
end
