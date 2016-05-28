defmodule Peepchat.SessionController do
  use Peepchat.Web, :controller

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt
  import Logger

  alias Peepchat.User

  def create(conn, %{
    "grant_type" => "password",
    "username" => username,
    "password" => password
  }) do
    try do
      user = User
      |> where(email: ^username)
      |> Repo.one!
      cond do
        # Success
        checkpw(password, user.password_hash) ->
          Logger.info "User " <> username <> " just logged in"
          {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
          conn
          |> json(%{access_token: jwt})

        # Failure
        true ->
          Logger.warning "User " <> username <> " just failed to log in"
          conn
          |> put_status(401)
          |> render(Peepchat.ErrorView, "401.json")
      end
    rescue  
      # Error
      e ->
        IO.inspect e
        Logger.error "Unexpected error while attempting to log in user " <> username
        conn
        |> put_status(401)
        |> render(Peepchat.ErrorView, "401.json")
    end
  end

  def create(_conn, %{"grant_type" => _}) do
    throw "Unsupported grant_type"
  end
end