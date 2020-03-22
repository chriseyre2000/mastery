use Mix.Config

config :mastery_persistence, MasteryPersistence.Repo, 
  database: "mastery_dev", 
  hostname: "localhost", 
  port: 54320, 
  username: "postgres", 
  password: "postgres"
                      
config :mastery, :persistence_fn, &Mastery.Persistence.record_response/2