# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :peepchat, Peepchat.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "7z5e3QYT2RrOlJvMHnurgGwQK86KOF/D+es5RLLTN/WqNFm3eJFQ1leRPtDEM9po",
  render_errors: [accepts: ~w(json)],
  pubsub: [name: Peepchat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures required JSONAPI encoder
config :phoenix, :format_encoders,
  "json-api": Poison

# Configures JSONAPI mimetype
config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

# Configures Guardian's JWT claims
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Peepchat",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET") || "+HIgXiOCeWj3wpyaqG34OWxLSohTmrSaPzVkrgNMqhZ1GI0hI4goJW0TMO7uqChs",
  serializer: Peepchat.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
