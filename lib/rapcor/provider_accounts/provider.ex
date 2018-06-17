defmodule Rapcor.ProviderAccounts.Provider do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, check_pass: 2]

  alias Ecto.Changeset
  @attrs [
    :administrative_area,
    :contact_email,
    :contact_number,
    :country,
    :locality,
    :name,
    :password,
    :password_confirmation,
    :postal_code,
    :premise,
    :thoroughfare
  ]

  schema "providers" do
    field :administrative_area, :string # State
    field :contact_email, :string
    field :contact_number, :string
    field :country, :string
    field :locality, :string # City
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :postal_code, :string
    field :premise, :string # Apartment, suite, etc.
    field :sub_administrative_area, :string # County
    field :thoroughfare, :string #Street and address

    timestamps()
  end

  @doc false
  def changeset(provider, attrs) do
    provider
    |> cast(attrs, @attrs)
    |> validate_required([:name, :contact_email, :contact_number, :country, :administrative_area, :locality, :postal_code, :premise, :thoroughfare])
    |> validate_format(:contact_email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_length(:password, min: 9, max: 100)
  end

  def create_changeset(provider, attrs) do
    provider
    |> cast(attrs, @attrs)
    |> validate_required([:name, :contact_email, :contact_number, :country, :administrative_area, :locality, :postal_code, :premise, :thoroughfare, :password, :password_confirmation])
    |> update_change(:contact_email, &(String.downcase(&1)))
    |> validate_format(:contact_email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_length(:password, min: 9, max: 100)
    |> unique_constraint(:contact_email)
    |> put_password
  end

  def put_password(changeset) do
    case changeset do
      %Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, hash_password(password))
      _ ->
        changeset
    end
  end

  def check_password(provider, password) do
    check_pass(provider, password)
  end

  def hash_password(password) do
    hashpwsalt(password)
  end

end
