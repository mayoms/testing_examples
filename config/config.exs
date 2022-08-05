import Config

config :testing_examples, ecto_repos: [TestingExamples.Repo]

config :testing_examples, TestingExamples.Repo, database: "testing_examples", pool_size: 2

# hostname: "localhost",
# port: "5432"

import_config "#{Mix.env()}.exs"
