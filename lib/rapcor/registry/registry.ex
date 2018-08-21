defmodule Rapcor.Registry do
  @moduledoc """
  The Registry context.
  """

  import Ecto.Query, warn: false
  alias Rapcor.Repo

  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.Registry.Request
  alias Rapcor.Registry.RequestBid

  @doc """
  Returns the list of requests by provider.

  ## Examples

      iex> list_provider_requests(provider_id)
      [%Request{}, ...]

  """
  def list_provider_requests(%Provider{} = provider) do
    query = from r in Request,
      where: r.provider_id == ^provider.id,
      preload: :request_experiences

    Repo.all(query)
  end

  @doc """
  Gets a single request.

  Raises `Ecto.NoResultsError` if the Request does not exist.

  ## Examples

      iex> get_request!(123)
      %Request{}

      iex> get_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_request!(id) do
    query = from r in Request,
      preload: :request_experiences

    Repo.get!(query, id)
  end

  @doc """
  Creates a request.

  ## Examples

      iex> create_request(%{field: value})
      {:ok, %Request{}}

      iex> create_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_request(attrs \\ %{}) do
    %Request{status: :pending}
    |> Request.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a request.

  ## Examples

      iex> update_request(request, %{field: new_value})
      {:ok, %Request{}}

      iex> update_request(request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_request(%Request{} = request, attrs) do
    request
    |> Request.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Request.

  ## Examples

      iex> delete_request(request)
      {:ok, %Request{}}

      iex> delete_request(request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_request(%Request{} = request) do
    Repo.delete(request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking request changes.

  ## Examples

      iex> change_request(request)
      %Ecto.Changeset{source: %Request{}}

  """
  def change_request(%Request{} = request) do
    Request.changeset(request, %{})
  end

  @doc """
  Create request bid.
  """
  def create_request_bid(%Request{} = request, %Clinician{} = clinician) do
    %RequestBid{}
    |> RequestBid.create_changeset(%{request_id: request.id, clinician_id: clinician.id})
    |> Repo.insert
  end
end
