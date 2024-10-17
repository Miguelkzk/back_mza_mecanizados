# This configuration file will be evaluated by Puma. The top-level methods that
# are invoked here are part of Puma's configuration DSL. For more information
# about methods provided by the DSL, see https://puma.io/puma/Puma/DSL.html.

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"

# Specifies the `port` that Puma will listen on to receive requests; default is 3000.
port ENV.fetch("PORT") { 3000 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch("RAILS_ENV") { "development" }

# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Specifies the number of worker processes to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together,
# the concurrency of the application will be `workers * max_threads`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).
if ENV["RAILS_ENV"] == "production"
  require "concurrent-ruby"
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count if worker_count > 1
end

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Hook that runs before forking in cluster mode
before_fork do
  PumaWorkerKiller.config do |config|
    config.ram           = 1024 # MB
    config.frequency     = 5    # seconds
    config.percent_usage = 0.98
  end

  PumaWorkerKiller.start

  # Ensure the server PID file is removed before booting Puma.
  File.exist?(Rails.root.join('tmp/pids/server.pid')) && File.delete(Rails.root.join('tmp/pids/server.pid'))
end
