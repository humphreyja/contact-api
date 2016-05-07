use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :contact_api, ContactApi.Endpoint,
  secret_key_base: "ajReSngVhHLvjqnit0MK+05CwMnEAOmF0k1mwwioGVwvT8Dnyqup23Y0q6ryiFzi"

# Configure your database
config :contact_api, ContactApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"},
  pool_size: 20
