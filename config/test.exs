use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :canon, CanonWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :canon, Canon.Repo,
  username: "postgres",
  password: "postgres",
  database: "canon_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
