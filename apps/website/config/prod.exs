use Mix.Config

config :logger, level: :info

config :website, WebsiteWeb.Endpoint,
  load_from_system_env: true,
  # Needed for Phoenix 1.2 and 1.4. Doesn't hurt for 1.3.
  http: [port: {:system, "PORT"}],
  # Without this line, your app will not start the web server!
  server: true,
  secret_key_base: "${SECRET_KEY_BASE}",
  # url: [host: "${APP_NAME}.gigalixirapp.com", port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json"
