defmodule ContactApi.UserTest do
  use ContactApi.ModelCase

  alias ContactApi.User

  @valid_attrs %{auth_expires_at: "2010-04-17 14:00:00", auth_id: "some content", auth_refresh_token: "some content", auth_token: "some content", crypted_password: "some content", first_name: "some content", last_name: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
