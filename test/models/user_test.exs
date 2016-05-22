defmodule Peepchat.UserTest do
  use Peepchat.ModelCase

  alias Peepchat.User

  @valid_attrs %{email: "some@content.com", 
    password: "some content",
    password_confirmation: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "mismatched password_confirmation fails" do
    changeset = User.changeset(%User{},
      %{email: "mrbiggs@mommashouse.net",
        password: "sdfhsd342fh@!",
        password_confirmation: "fd03ngdkd.."})
    refute changeset.valid?
  end

  test "missing password_confirmation fails" do
    changeset = User.changeset(%User{},
      %{email: "mrbiggs@mommashouse.net",
        password: "sdfhsd342fh@!"})
    refute changeset.valid?
  end

  test "short password fails" do
    changeset = User.changeset(%User{},
      %{email: "mrbiggs@mommashouse.net",
        password: "sdf@!",
        password_confirmation: "sdf@!"})
    refute changeset.valid?
  end
end
