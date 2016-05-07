defmodule ContactApi.User do
  use ContactApi.Web, :model

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :auth_id, :string
    field :auth_token, :string
    field :auth_expires_at, Ecto.DateTime
    field :auth_refresh_token, :string
    field :username, :string
    field :crypted_password, :string

    timestamps
  end

  @required_fields ~w(first_name last_name auth_id auth_token auth_expires_at auth_refresh_token username crypted_password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:username)
  end
end
