defmodule CanonWeb.UserController do
  use CanonWeb, :controller

  alias Canon.Accounts
  alias Canon.Accounts.User
  alias Canon.Auth.Guardian

  action_fallback(CanonWeb.FallbackController)

  def create(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params) do
      new_conn = Guardian.Plug.sign_in(conn, user)
      jwt = Guardian.Plug.current_token(new_conn)

      new_conn
      |> put_status(:created)
      |> render(CanonWeb.SessionView, "show.json", user: user, jwt: jwt)
    end
  end
end
