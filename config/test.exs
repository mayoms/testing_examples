import Config

config :logger, level: :warn

config :testing_examples, p_mod: PermissionMock

config :testing_examples, TestingExamples.Repo, pool: Ecto.Adapters.SQL.Sandbox
