defmodule CanonWeb.UserControllerTest do
  use CanonWeb.ConnCase

  alias Canon.Accounts

  @create_attrs %{username: "some username", email: "some@email", password: "some password"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates a user when the required parameters are provided", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), @create_attrs)
    response = json_response(conn, 201)

    assert %{"id" => _id, "username" => "some username", "email" => "some@email"} =
             response["data"]

    refute Map.get(response["data"], :password)
    assert %{"token" => _token} = response["meta"]
  end

  test "doesn't create a user if incorrect params provided", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), @invalid_attrs)
    response = json_response(conn, 422)

    assert %{"email" => _email, "password" => _password} = response["errors"]
    refute response["meta"]
  end

  test "doesn't create a user if email already taken", %{conn: conn} do
    Accounts.create_user(@create_attrs)
    conn = post(conn, user_path(conn, :create), @create_attrs)
    response = json_response(conn, 422)

    assert %{"email" => ["has already been taken"]} = response["errors"]
    refute response["meta"]
  end
end
