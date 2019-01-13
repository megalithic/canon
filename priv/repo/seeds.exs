# users
user =
  Canon.Accounts.User.registration_changeset(%Canon.Accounts.User{}, %{
    username: "megalithic",
    email: "seth.messer@gmail.com",
    password: "Password1"
  })

Canon.Repo.insert!(user)
