defmodule ContactApi.PageController do
  use ContactApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
