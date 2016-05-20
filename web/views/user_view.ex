defmodule ContactApi.UserView do
  use ContactApi.Web, :view

  def render("index.json", %{users: users}) do
    render_many(users, ContactApi.UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, ContactApi.UserView, "user.json")
  end

  def render("new.json", %{user: user, session: session}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      user_name: user.username,
      auth_token: session.token}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      username: user.username}
  end
end
