defmodule ContactApi.ApiTokenTest do
  use ContactApi.ModelCase

  alias ContactApi.ApiToken

  @valid_attrs %{name: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ApiToken.changeset(%ApiToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ApiToken.changeset(%ApiToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
