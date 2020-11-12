defmodule JalamaScrapper.Repo do
  use Ecto.Repo,
    otp_app: :jalama_scrapper,
    adapter: Ecto.Adapters.Postgres
end
