defmodule Peepchat.Router do
  use Peepchat.Web, :router

  # Unauthenticated requests
  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", Peepchat do
    pipe_through :api

    # New user registration
    post "register", RegistrationController, :create

    # Login
    post "token", SessionController, :create, as: :login
  end

  scope "/api", Peepchat do
    pipe_through :api_auth
    get "user/current", UserController, :current
  end
end
