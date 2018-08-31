use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rapcor, RapcorWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rapcor, Rapcor.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rapcor_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :rapcor, Rapcor.PhotoStorage,
  bucket: "rapcor-dev"

config :exq,
  name: Exq,
  host: "localhost",
  port: 6379,
  namespace: "exq_test",
  concurrency: :infinite,
  queues: ["default"],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 25,
  shutdown_timeout: 5000,
  start_on_application: false

config :rapcor,
  worker_queue: Rapcor.MockQueue
