defmodule TestingExamples.Repo do
  use Ecto.Repo,
    otp_app: :testing_examples,
    adapter: Ecto.Adapters.Postgres
end
