defmodule Rapcor.Registry do
  @moduledoc """
  The Registry context.
  """

  import Ecto.Query, warn: false
  alias Rapcor.Repo

  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.ClinicianAccounts.ClinicianExperience
  alias Rapcor.Registry.Request
  alias Rapcor.Registry.Request.Enums.RequestStatus
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
    %Request{status: :open}
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

  @doc """
  Returns a list of eligible clinicians for a request.

  Clinicians should be approved, have valid documents, and meet the required
  experience.

  ## Options

    * `:limit` - Maximum number of eligible clinicians to return, defaults to 10

  ## Examples

      iex> list_eligible_clinicians(request)
      [%Clinician{}, %Clinician{}]

  """
  def list_eligible_clinicians(%Request{} = request, opts \\ []) do
    limit = Keyword.get(opts, :limit, 10)

    request = Repo.preload request, :request_experiences

    query = from c in Clinician,
      join: ce in ClinicianExperience, on: ce.clinician_id == c.id,
      group_by: c.id,
      select: c,
      limit: ^limit

    query
    |> query_clinicians_by_experience(request.request_experiences)
    |> Repo.all
  end

  defp query_clinicians_by_experience(query, []), do: query

  defp query_clinicians_by_experience(query, request_experiences) do
    experience_ids = Enum.map(request_experiences, &(&1.experience_id))

    from [_c, ce] in query,
      where: ce.experience_id in ^experience_ids
  end

  @doc """
  Accepts a request bid on behalf of a clinician.

  A request bid will be accepted only if it is open and
  no other clinicians have accepted the request.

  ## Examples
  
      iex> accepted_request_bid(request_bid)
      {:ok, %Request{}}

      iex> accepted_request_bid(request_bid)
      {:error, "Request no longer available"}
  """
  def accept_request_bid(%RequestBid{} = request_bid) do
    request_bid = Repo.preload request_bid, :request

    query = from r in Request,
      where: r.id == ^request_bid.request_id,
      where: r.status == ^RequestStatus.__enum_map__[:open],
      where: is_nil(r.accepted_clinician_id)
      
    update = [
      status: RequestStatus.__enum_map__[:fulfilled],
      accepted_clinician_id: request_bid.clinician_id,
      updated_at: DateTime.utc_now()
    ]

    case Repo.update_all(query, [set: update], returning: true) do
      {1, [request]} ->
        {:ok, request}
      _ ->
        {:error, "Request no longer available"}
    end
  end
end
