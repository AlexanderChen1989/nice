defmodule Nice.Repo do
  use Ecto.Repo, otp_app: :nice
  use Scrivener, page_size: 10
end
