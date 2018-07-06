defmodule Rapcor.ClinicianAccounts.Clinician do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1, check_pass: 2]

  alias Ecto.Changeset
  alias Rapcor.ClinicianAccounts.Experience

  @attrs [
    :first_name,
    :last_name,
    :middle_name,
    :email,
    :phone_number,
    :country,
    :administrative_area,
    :sub_administrative_area,
    :locality,
    :postal_code,
    :thoroughfare,
    :premise,
    :password
  ]

  @create_required_attrs [
    :first_name,
    :last_name,
    :email,
    :phone_number,
    :country,
    :administrative_area,
    :locality,
    :postal_code,
    :thoroughfare,
    :password
  ]


  schema "clinicians" do
    field :administrative_area, :string # State
    field :country, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :locality, :string # City
    field :middle_name, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone_number, :string
    field :postal_code, :string
    field :premise, :string # Apartment, suite, etc.
    field :sub_administrative_area, :string # County
    field :thoroughfare, :string # Street and address

    many_to_many :experiences, Experience, join_through: "clinicians_experiences"

    timestamps()
  end

  @doc false
  def changeset(clinician, attrs) do
    clinician
    |> cast(attrs, [:first_name, :last_name, :middle_name, :email, :phone_number, :country, :administrative_area, :locality, :postal_code, :premise, :sub_administrative_area, :thoroughfare, :password_hash])
    |> validate_required([:first_name, :last_name, :email, :phone_number, :country, :administrative_area, :locality, :postal_code, :thoroughfare, :password_hash])
  end

  def create_changeset(clinician, attrs) do
    clinician
    |> cast(attrs, @attrs)
    |> validate_required(@create_required_attrs)
    |> update_change(:email,  &(String.downcase(&1)))
    |> validate_format(:email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_length(:password, min: 9, max: 100)
    |> unique_constraint(:email)
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

  def check_password(clinician, password) do
    check_pass(clinician, password)
  end

  def hash_password(password) do
    hashpwsalt(password)
  end
end
