defmodule RapcorWeb.DocumentController do
  use RapcorWeb, :controller

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.Document
  alias Rapcor.Authorization.ClinicianAuthPlug
  alias Rapcor.PhotoStorage

  action_fallback RapcorWeb.FallbackController

  plug ClinicianAuthPlug

  def index(conn, _params) do
    clinician = current_clinician(conn)
    documents = ClinicianAccounts.list_clinician_documents(clinician)
    render(conn, "index.json", documents: documents)
  end

  def create(conn, %{"document" => document_params}) do
    clinician = current_clinician(conn)

    document_params = document_params
    |> Map.put("clinician_id", clinician.id)
    |> process_front_photo()
    |> process_back_photo()

    with {:ok, %Document{} = document} <- ClinicianAccounts.create_document(document_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", current_clinician_document_path(conn, :show, document))
      |> render("show.json", document: document)
    end
  end

  def show(conn, %{"id" => id}) do
    document = ClinicianAccounts.get_document!(id)

    case document.clinician_id == current_clinician(conn).id do
      true ->
        render(conn, "show.json", document: document)
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end

  def update(conn, %{"id" => id, "document" => document_params}) do
    document = ClinicianAccounts.get_document!(id)

    case document.clinician_id == current_clinician(conn).id do
      true ->
        document_params = document_params
                          |> process_front_photo()
                          |> process_back_photo()

        with {:ok, %Document{} = document} <- ClinicianAccounts.update_document(document, document_params) do
          render(conn, "show.json", document: document)
        end
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    document = ClinicianAccounts.get_document!(id)

    case document.clinician_id == current_clinician(conn).id do
      true ->
        with {:ok, %Document{}} <- ClinicianAccounts.delete_document(document) do
          send_resp(conn, :no_content, "")
        end
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end

  defp process_front_photo(%{"front_photo" => %Plug.Upload{path: path}} = params) do
    case PhotoStorage.upload_file(path) do
      {:ok, photo_url} ->
        %{params | "front_photo" => photo_url}
      _ ->
        %{params | "front_photo" => nil}
    end
  end

  defp process_front_photo(params), do: params

  defp process_back_photo(%{"back_photo" => %Plug.Upload{path: path}} = params) do
    case PhotoStorage.upload_file(path) do
      {:ok, photo_url} ->
        %{params | "back_photo" => photo_url}
      _ ->
        %{params | "back_photo" => nil}
    end
  end

  defp process_back_photo(params), do: params
end
