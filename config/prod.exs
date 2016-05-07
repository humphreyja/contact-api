use Mix.Config

config :contact_api, ContactApi.Endpoint,
  http: [port: {:system, "PORT"}],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  url: [host: System.get_env("HOST"), port: 443, scheme: "https"]

config :contact_api, ContactApi.Repo,
  adapter:    Ecto.Adapters.Postgres,
  pool_size:  20,
  url:        System.get_env("DATABASE_URL")


# Do not print debug messages in production
config :logger, level: :info
