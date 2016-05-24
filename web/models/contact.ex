defmodule ContactApi.Contact do
  use ContactApi.Web, :model
  require Apex
  schema "contacts" do
    field :name, :string
    field :email, :string
    field :phone_number, :string
    field :data_version, :integer
    field :data_update_time, :integer
    belongs_to :user, ContactApi.User

    timestamps
  end



  @required_fields ~w()
  @optional_fields ~w(name email phone_number data_version data_update_time)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_one
    |> version_object
  end

  defp validate_one(changeset) do
    cond do
      get_change(changeset, :name) ->
        changeset
      get_change(changeset, :email) ->
        changeset
      get_change(changeset, :phone_number) ->
        changeset
      true ->
        changeset = add_error(changeset, :name, "Requires at least one")
        changeset = add_error(changeset, :email, "Requires at least one")
        changeset = add_error(changeset, :phone_number, "Requires at least one")
        changeset
    end
  end

  def versioned_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_version_params
    |> check_version
    |> version_object
  end

  defp validate_version_params(changeset) do
    cond do
      !get_change(changeset, :data_version) ->
        changeset = add_error(changeset, :data_version, "Requires a version number")
        changeset
      !get_change(changeset, :data_update_time) ->
        changeset = add_error(changeset, :data_update_time, "Requires update timestamp")
        changeset
      true ->
        changeset
    end
  end

  defp check_version(changeset) do
    if changeset.valid? do
      if changeset.model.data_version > changeset.changes.data_version do
        if changeset.model.data_update_time > changeset.changes.data_update_time do
          changeset = add_error(changeset, :data_version, "Rejecting old change")
        end
      end
    end
    changeset
  end

  defp version_object(changeset) do
    if changeset.valid? do
      changeset = put_change(changeset, :data_version, changeset.model.data_version + 1)
      changeset = put_change(changeset, :data_update_time, :os.system_time(:seconds))
    end

    changeset
  end
end
