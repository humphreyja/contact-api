defmodule ContactApi.SessionController do
  use ContactApi.Web, :controller

  require Apex

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias ContactApi.User
  alias ContactApi.Session

  # SIGN IN
  def create(conn, %{"user" => user_params}) do
    user = Repo.get_by(User, username: user_params["username"])
    cond do
      user && checkpw(user_params["password"], user.crypted_password) ->

        session = find_or_create_session(user)
        conn
        |> put_status(:created)
        |> render("show.json", session: session)
      user ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
      true ->
        dummy_checkpw
        conn
        |> put_status(:unauthorized)
        |> render("error.json", user_params)
    end
  end

  defp find_or_create_session(user) do
    query = from s in Session, where: s.user_id == ^user.id, limit: 1
    case Repo.one(query) do
      nil     ->
            session_changeset = Session.registration_changeset(%Session{}, %{user_id: user.id})
            {:ok, session} = Repo.insert(session_changeset)
            session
            
      session -> session

    end
  end
end
