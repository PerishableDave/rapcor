use Mix.Config

# For production, we often load configuration from external
# sources, such as your system environment. For this reason,
# you won't find the :http configuration below, but set inside
# RapcorWeb.Endpoint.init/2 when load_from_system_env is
# true. Any dynamic configuration should be done there.
#
# Don't forget to configure the url host to something meaningful,
# Phoenix uses this information when generating URLs.
#
# Finally, we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the mix phx.digest task
# which you typically run after static files are built.
config :rapcor, RapcorWeb.Endpoint,
  load_from_system_env: true,
  url: [scheme: "https", host: "api.rapcor.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]]

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :rapcor, RapcorWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [:inet6,
#               port: 443,
#               keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#               certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables return an absolute path to
# the key and cert in disk or a relative path inside priv,
# for example "priv/ssl/server.key".
#
# We also recommend setting `force_ssl`, ensuring no data is
# ever sent via http, always redirecting to https:
#
#     config :rapcor, RapcorWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :rapcor, RapcorWeb.Endpoint, server: true
#

# Finally import the config/prod.secret.exs
# which should be versioned separately.
# import_config "prod.secret.exs"

config :rapcor, RapcorWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :rapcor, Rapcor.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
	ssl: true

config :cors_plug,
  origin: ["https://www.rapcor.com"],
  max_age: 86400,
  methods: ["GET", "POST", "PUT", "DELETE"]

config :ex_aws,
  access_key_id: [System.get_env("AWS_S3_ACCESS_KEY"), :instance_role],
  secret_access_key: [System.get_env("AWS_S3_SECRET_KEY"), :instance_role],
  region: "us-west-1"

config :rapcor, Rapcor.PhotoStorage,
  bucket: "rapcor-prod"

config :exq,
  name: Exq,
  host: System.get_env("REDISCLOUD_URL"),
  port: 6379,
  namespace: "exq",
  concurrency: :infinite,
  queues: ["default"],
  poll_timeout: 50,
  scheduler_poll_timeout: 200,
  scheduler_enable: true,
  max_retries: 25,
  shutdown_timeout: 5000,
  start_on_application: false
