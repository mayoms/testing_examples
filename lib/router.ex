defmodule TestingExamples.Router do
  use Plug.Router

  alias TestingExamples.Users

  def init(opts), do: opts

  plug Plug.Logger
  plug :match
  plug :current_user
  plug :ensure_authenticated
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  match _, do: send_resp(conn, 404, "not found")

  def current_user(conn, _opts) do
    case get_req_header(conn, "x-user-id") do
      [user_id] ->
        assign(conn, :current_user, Users.find(user_id))

      _ ->
        conn
    end
  end

  def ensure_authenticated(%{assigns: assigns} = conn, _opts) do
    case assigns[:current_user] do
      nil -> send_resp(conn, 403, "unauthorized") |> halt()
      _ -> conn
    end
  end
end
