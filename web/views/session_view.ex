defmodule ContactApi.SessionView do
  use ContactApi.Web, :view

  def render("show.json", %{session: session}) do
    %{data: render_one(session, ContactApi.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{auth_token: session.token}
  end

  def render("error.json", _anything) do
    %{errors: "failed to authenticate"}
  end
end
