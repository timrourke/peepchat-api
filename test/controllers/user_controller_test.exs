defmodule Peepchat.UserControllerTest do
	use Peepchat.ConnCase
	import Ecto.Query, only: [where: 2]

	alias Peepchat.Repo
	alias Peepchat.User

	setup %{conn: conn} do
		{:ok, conn: put_req_header(conn, "accept", "application/json")}
	end

	test "does show user and renders it when JWT is valid", %{conn: conn} do
		user_changeset = User.changeset %User{}, %{
		  email: "testy.mctesterson8@gmail.com",
		  password: "thisismyfakepassword123!",
		  password_confirmation: "thisismyfakepassword123!"
		}

		Repo.insert!(user_changeset)

		user = User
		|> where(email: "testy.mctesterson8@gmail.com")
		|> Repo.one!
		
		{:ok, jwt, _} = Guardian.encode_and_sign(user, :token)
		conn = put_req_header(conn, "authorization", "Bearer " <> jwt)
		conn = get conn, user_path(conn, :current), nil

		body = json_response(conn, 200)

		assert(body["data"]["id"] > 0, "should have id")
		assert(body["data"]["attributes"]["email"] == "testy.mctesterson8@gmail.com", 
			"rendered user should match JWT")

		on_exit fn -> 
			Repo.delete_all(User)
		end
	end

	test "does not show user and renders errors when data is invalid", %{conn: conn} do
		conn = get conn, user_path(conn, :current), []

		assert json_response(conn, 401)
	end
end