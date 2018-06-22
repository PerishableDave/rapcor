defmodule Rapcor.ProviderAccounts do
  @moduledoc """
  The ProviderAccounts context.
  """

  import Ecto.Query, warn: false
  alias Rapcor.Repo

  alias Rapcor.ProviderAccounts.Provider

  @doc """
  Returns the list of providers.

  ## Examples

      iex> list_providers()
      [%Provider{}, ...]

  """
  def list_providers do
    Repo.all(Provider)
  end

  @doc """
  Gets a single provider.

  Raises `Ecto.NoResultsError` if the Provider does not exist.

  ## Examples

      iex> get_provider!(123)
      %Provider{}

      iex> get_provider!(456)
      ** (Ecto.NoResultsError)

  """
  def get_provider!(id), do: Repo.get!(Provider, id)

  @doc """
  Creates a provider.

  ## Examples

      iex> create_provider(%{field: value})
      {:ok, %Provider{}}

      iex> create_provider(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_provider(attrs \\ %{}) do
    %Provider{}
    |> Provider.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a provider.

  ## Examples

      iex> update_provider(provider, %{field: new_value})
      {:ok, %Provider{}}

      iex> update_provider(provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_provider(%Provider{} = provider, attrs) do
    provider
    |> Provider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Provider.

  ## Examples

      iex> delete_provider(provider)
      {:ok, %Provider{}}

      iex> delete_provider(provider)
      {:error, %Ecto.Changeset{}}

  """
  def delete_provider(%Provider{} = provider) do
    Repo.delete(provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking provider changes.

  ## Examples

      iex> change_provider(provider)
      %Ecto.Changeset{source: %Provider{}}

  """
  def change_provider(%Provider{} = provider) do
    Provider.changeset(provider, %{})
  end

  alias Rapcor.ProviderAccounts.ProviderToken

  @doc """
  Gets a single provider_token.

  Raises `Ecto.NoResultsError` if the Provider token does not exist.

  ## Examples

      iex> get_provider_token!(123)
      %ProviderToken{}

      iex> get_provider_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_provider_token!(id), do: Repo.get!(ProviderToken, id)

  @doc """
  Creates a provider_token.

  ## Examples

      iex> create_provider_token(%{field: value})
      {:ok, %ProviderToken{}}

      iex> create_provider_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_provider_token(email, password, opts \\ []) do
    source = Keyword.get(opts, :source)

    with provider <- Repo.get_by(Provider, contact_email: email)
         {:ok, _provider} <- Provider.check_password(provider, password),
         changeset <- ProviderToken.changeset(%ProviderToken{}, %{source: source, provider_id: provider.id}),
         {:ok, token} <- Repo.insert(changeset)
    do
      {:ok, token}
    else
      {:error, :unauthorized}
    end
  end

  @doc """
  Deletes a ProviderToken.

  ## Examples

      iex> delete_provider_token(provider_token)
      {:ok, %ProviderToken{}}

      iex> delete_provider_token(provider_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_provider_token(%ProviderToken{} = provider_token) do
    Repo.delete(provider_token)
  end

end
