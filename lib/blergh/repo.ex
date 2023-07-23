defmodule Blergh.Repo do
  use Ecto.Repo,
    otp_app: :blergh,
    adapter: Ecto.Adapters.Postgres
end
