defmodule Rapcor.ClinicianAccounts.Document.RespiratoryTherapist do
  @rt_rcp_attrs [:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id]
  @rt_crt_attrs [:slug, :number, :expiration, :front_photo, :back_photo, :clinician_id]
  @rt_rrt_attrs [:slug, :number, :expiration, :front_photo, :back_photo, :clinician_id]

  def document_attrs("rt-rcp"), do: @rt_rcp_attrs
  def document_attrs("rt-crt"), do: @rt_crt_attrs
  def document_attrs("rt-rrt"), do: @rt_rrt_attrs
end
