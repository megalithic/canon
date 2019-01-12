defmodule Canon.Repo do
  use Ecto.Repo,
    otp_app: :canon,
    adapter: Ecto.Adapters.Postgres
end
