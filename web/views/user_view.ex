defmodule ContactApi.UserView do
  use ContactApi.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, ContactApi.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, ContactApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      auth_id: user.auth_id,
      auth_token: user.auth_token,
      auth_expires_at: user.auth_expires_at,
      auth_refresh_token: user.auth_refresh_token,
      username: user.username,
      crypted_password: user.crypted_password}
  end
end
