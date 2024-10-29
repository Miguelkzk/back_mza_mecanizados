max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 2 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

if ENV["RAILS_ENV"] == "production"
  worker_count = 1 # Limitar a 1 trabajador si es posible.
  workers worker_count
end

before_fork do
  PumaWorkerKiller.config do |config|
    config.ram           = 512 # Ajustado para Railway
    config.frequency     = 5 * 60
    config.percent_usage = 0.9
    config.rolling_restart_frequency = 12 * 3600
  end
  PumaWorkerKiller.start
end
