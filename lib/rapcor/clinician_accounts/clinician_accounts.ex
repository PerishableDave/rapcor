defmodule Rapcor.ClinicianAccounts do
  @moduledoc """
  The ClinicianAccounts context.
  """

  import Ecto.Query, warn: false
  alias Rapcor.Repo

  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.ClinicianAccounts.ClinicianToken

  @doc """
  Returns the list of clinicians.

  ## Examples

      iex> list_clinicians()
      [%Clinician{}, ...]

  """
  def list_clinicians do
    Repo.all(Clinician)
  end

  @doc """
  Gets a single clinician.

  Raises `Ecto.NoResultsError` if the Clinician does not exist.

  ## Examples

      iex> get_clinician!(123)
      %Clinician{}

      iex> get_clinician!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clinician!(id), do: Repo.get!(Clinician, id)

  @doc """
  Creates a clinician.

  ## Examples

      iex> create_clinician(%{field: value})
      {:ok, %Clinician{}}

      iex> create_clinician(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clinician(attrs \\ %{}) do
    %Clinician{}
    |> Clinician.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clinician.

  ## Examples

      iex> update_clinician(clinician, %{field: new_value})
      {:ok, %Clinician{}}

      iex> update_clinician(clinician, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clinician(%Clinician{} = clinician, attrs) do
    clinician
    |> Clinician.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Clinician.

  ## Examples

      iex> delete_clinician(clinician)
      {:ok, %Clinician{}}

      iex> delete_clinician(clinician)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clinician(%Clinician{} = clinician) do
    Repo.delete(clinician)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clinician changes.

  ## Examples

      iex> change_clinician(clinician)
      %Ecto.Changeset{source: %Clinician{}}

  """
  def change_clinician(%Clinician{} = clinician) do
    Clinician.changeset(clinician, %{})
  end

  def get_clinician_by_token(token) do
    query = from c in Clinician,
      join: t in ClinicianToken, on: t.clinician_id == c.id,
      where: t.id == ^token,
      select: c


    Repo.one(query)
  end

  @doc """
  Gets a single clinician_token.

  Raises `Ecto.NoResultsError` if the Auth token does not exist.

  ## Examples

      iex> get_clinician_token!(123)
      %ClinicianToken{}

      iex> get_clinician_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clinician_token!(id), do: Repo.get!(ClinicianToken, id)

  @doc """
  Creates a clinician_token.

  ## Examples

      iex> create_clinician_token(%{field: value})
      {:ok, %ClinicianToken{}}

      iex> create_clinician_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clinician_token(email, password, opts \\ []) do
    source = Keyword.get(opts, :source)

    result = with clinician <- Repo.get_by(Clinician, email: email),
         {:ok, _user} <- Clinician.check_password(clinician, password),
         changeset <- ClinicianToken.changeset(%ClinicianToken{}, %{source: source, clinician_id: clinician.id}),
         do: Repo.insert(changeset)

    case result do
      {:ok, _} ->
        result
      _ ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a ClinicianToken.

  ## Examples

      iex> delete_clinician_token(clinician_token)
      {:ok, %ClinicianToken{}}

      iex> delete_clinician_token(clinician_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clinician_token(%ClinicianToken{} = clinician_token) do
    Repo.delete(clinician_token)
  end

  alias Rapcor.ClinicianAccounts.Experience

  @doc """
  Returns the list of experiences.

  ## Examples

      iex> list_experiences()
      [%Experience{}, ...]

  """
  def list_experiences do
    Repo.all(Experience)
  end

  @doc """
  Gets a single experience.

  Raises `Ecto.NoResultsError` if the Experience does not exist.

  ## Examples

      iex> get_experience!(123)
      %Experience{}

      iex> get_experience!(456)
      ** (Ecto.NoResultsError)

  """
  def get_experience!(id), do: Repo.get!(Experience, id)

  @doc """
  Creates a experience.

  ## Examples

      iex> create_experience(%{field: value})
      {:ok, %Experience{}}

      iex> create_experience(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_experience(attrs \\ %{}) do
    %Experience{}
    |> Experience.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a experience.

  ## Examples

      iex> update_experience(experience, %{field: new_value})
      {:ok, %Experience{}}

      iex> update_experience(experience, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_experience(%Experience{} = experience, attrs) do
    experience
    |> Experience.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Experience.

  ## Examples

      iex> delete_experience(experience)
      {:ok, %Experience{}}

      iex> delete_experience(experience)
      {:error, %Ecto.Changeset{}}

  """
  def delete_experience(%Experience{} = experience) do
    Repo.delete(experience)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking experience changes.

  ## Examples

      iex> change_experience(experience)
      %Ecto.Changeset{source: %Experience{}}

  """
  def change_experience(%Experience{} = experience) do
    Experience.changeset(experience, %{})
  end
end
