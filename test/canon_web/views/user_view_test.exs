defmodule CanonWeb.UserViewTest do
  use CanonWeb.ConnCase, async: true

  alias Canon.Accounts
  alias CanonWeb.UserView

  @user_params %{username: "some username", email: "some@email", password: "some password"}

  test "index.json" do
    {:ok, user} = Accounts.create_user(@user_params)

    assert UserView.render("user.json", %{user: user}) == %{
             id: user.id,
             username: user.username,
             email: user.email
           }
  end
end
