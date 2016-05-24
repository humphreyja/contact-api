defmodule ContactApi.Authentication do
  import Plug.Conn
  require Logger
  require Apex
  alias ContactApi.{Repo, User, Session}
  import Ecto.Query, only: [from: 2]

  def init(options), do: options

  def call(conn, _opts) do
    case find_user(conn) do
      {:ok, user} -> assign(conn, :current_user, user)
      _otherwise  -> auth_error!(conn)
    end
  end

  defp find_user(conn) do
    with {:ok, token} <- get_token(conn),
         {:ok, session} <- find_session_by_token(token),
    do:  find_user_by_session(session)
  end

  defp get_token(conn) do
    #case get_req_header(conn, "authorization") do
    #  {:ok, header} -> get_token_from_header(header)
    #  _otherwise -> get_token_from_params(conn.params)
    #end
    get_token_from_params(conn.params)
  end

  defp get_token_from_header(["Token auth_token=" <> token]) do
    {:ok, String.replace(token, ~r/(\"|\')/, "")}
  end

  defp get_token_from_header(_non_token_header) do
    :error
  end

  defp get_token_from_params(%{"auth_token" => token}) do
    {:ok, String.replace(token, ~r/(\"|\')/, "")}
  end

  defp get_token_from_params(_no_token_in_params) do
    Logger.debug "No auth token provided"
    :error
  end


  defp find_session_by_token(token) do
    case Repo.get_by(Session, token: token) do
      nil     -> :error
      session -> {:ok, session}
    end
  end

  defp find_user_by_session(session) do
    case Repo.get(User, session.user_id) do
      nil  -> :error
      user -> {:ok, user}
    end
  end

  defp auth_error!(conn) do
    Logger.debug "Unauthorized user attempt"
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(ContactApi.ErrorView, "403.json", %{message: "Unauthorized"})
    |> halt
  end
end
