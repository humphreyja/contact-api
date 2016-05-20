defmodule ContactApi.AuthorizeApi do
  import Plug.Conn
  require Logger
  alias ContactApi.{Repo, ApiToken}
  import Ecto.Query, only: [from: 2]

  def init(options), do: options

  def call(conn, _opts) do
    Apex.ap conn.params
    case find_token(conn) do
      {:ok, _token} -> conn
      _otherwise   -> auth_error!(conn)
    end
  end

  defp find_token(conn) do
    with {:ok, req_token} <- get_token(conn),
      {:ok, api_token} <- find_api_token(req_token),
    do: {:ok, api_token}
  end

  defp get_token(conn) do
    #case get_req_header(conn, "authorization") do
    #  {:ok, header} -> get_token_from_header(header)
    #  _otherwise -> get_token_from_params(conn.params)
    #end

    get_token_from_params(conn.params)
  end

  defp get_token_from_header(["Token api_token=" <> token]) do
    {:ok, String.replace(token, ~r/(\"|\')/, "")}
  end

  defp get_token_from_header(_non_token_header) do
    :error
  end

  defp get_token_from_params(%{"api_token" => token}) do
    {:ok, String.replace(token, ~r/(\"|\')/, "")}
  end

  defp get_token_from_params(_no_token_in_params) do
    Logger.debug "No auth token provided"
    :error
  end


  defp find_api_token(token) do
    case Repo.get_by(ApiToken, token: token) do
      nil     -> :error
      token -> {:ok, token}
    end
  end

  defp auth_error!(conn) do
    Logger.debug "Unauthorized application attempt"
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(ContactApi.ErrorView, "403.json", %{message: "Unauthorized"})
    |> halt
  end
end
