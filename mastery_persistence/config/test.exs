use Mix.Config

config :mastery_persistence, MasteryPersistence.Repo,
  database: "mastery_test",
  hostname: "localhost",
  port: 54320,
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "postgres",
  password: "postgres"