defmodule Canon.AccountsTest do
  use Canon.DataCase

  alias Canon.Accounts

  describe "users" do
    alias Canon.Accounts.User

    @valid_attrs %{
      username: "some username",
      email: "some@email",
      password: "some password"
    }
    @update_attrs %{
      username: "some updated username",
      email: "updated@email",
      password: "some updated password"
    }

    def user_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(@valid_attrs)
      |> Accounts.create_user()
    end

    test "list_users/0 returns all users" do
      assert {:ok, user} = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user/1 returns the user with given id" do
      assert {:ok, user} = user_fixture()
      assert Accounts.get_user(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, user} = user_fixture()
      assert user.username == "some username"
      assert user.email == "some@email"
      refute is_nil(user.password_hash)
      assert Comeonin.Argon2.checkpw("some password", user.password_hash)
    end

    test "create_user/1 requires a username" do
      assert {:error, changeset} = user_fixture(%{username: nil})
      assert "can't be blank" in errors_on(changeset).username

      assert {:error, changeset} = user_fixture(%{username: ""})
      assert "can't be blank" in errors_on(changeset).username
    end

    test "create_user/1 validates that username is at least 2 chars" do
      assert {:error, changeset} = user_fixture(%{username: "a"})
      assert "should be at least 2 character(s)" in errors_on(changeset).username
    end

    test "create_user/1 validates that username is at most 255 chars" do
      assert {:error, changeset} = user_fixture(%{username: long_string(256)})
      assert "should be at most 255 character(s)" in errors_on(changeset).username
    end

    test "create_user/1 requires an email" do
      assert {:error, changeset} = user_fixture(%{email: nil})
      assert "can't be blank" in errors_on(changeset).email

      assert {:error, changeset} = user_fixture(%{email: ""})
      assert "can't be blank" in errors_on(changeset).email
    end

    test "create_user/1 validates that email is at least 5 chars" do
      assert {:error, changeset} = user_fixture(%{email: "a"})
      assert "should be at least 5 character(s)" in errors_on(changeset).email
    end

    test "create_user/1 validates that email is at most 255 chars" do
      assert {:error, changeset} = user_fixture(%{email: long_string(256)})
      assert "should be at most 255 character(s)" in errors_on(changeset).email
    end

    test "create_user/1 validates that email contains the @ char" do
      assert {:error, changeset} = user_fixture(%{email: "abcde"})
      assert "has invalid format" in errors_on(changeset).email
    end

    test "update_user/2 with valid data updates the user" do
      {:ok, user} = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "updated@email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      {:ok, user} = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{username: nil})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{username: ""})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{email: nil})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{email: ""})
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{email: "abcde"})
      assert user == Accounts.get_user(user.id)
    end

    test "update_user/2 doesn't change the password" do
      {:ok, user} = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert Comeonin.Argon2.checkpw("some password", user.password_hash)
    end

    test "delete_user/1 deletes the user" do
      {:ok, user} = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert nil == Accounts.get_user(user.id)
    end

    test "change_user/1 returns a user changeset" do
      {:ok, user} = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "change_user/1 doesn't modify the password" do
      {:ok, user} = user_fixture(%{password: "changed password"})
      changeset = Accounts.change_user(user)
      assert %Ecto.Changeset{} = changeset
      assert get_change(changeset, :password) == nil
    end

    test "authenticate/2 verifies the user exists" do
      {:ok, user} = user_fixture()
      {:ok, auth_user} = Accounts.authenticate(user.email, "some password")
      assert auth_user == user
    end

    test "authenticate/2 works correctly with no user provided" do
      assert :error = Accounts.authenticate("other@user", "some password")
    end
  end
end
