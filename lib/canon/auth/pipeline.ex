defmodule Canon.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :canon,
    module: Canon.Auth.Guardian,
    error_handler: Canon.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
