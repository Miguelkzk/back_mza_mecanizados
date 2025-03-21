source "https://rubygems.org"

ruby "3.3.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# gem for postgres
gem 'pg', '>= 0.18', '< 2.0'

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
   gem 'byebug', '~> 11.1', '>= 11.1.3'
end

gem 'google-apis-drive_v3', '~> 0.16'
gem 'googleauth', '~> 0.16'

gem 'amazing_print'
gem 'rack-cors', require: 'rack/cors'

# gema para generar excel
gem 'caxlsx_rails'
# gema para la paginacion
gem 'kaminari'

# gemas para la autenticacion
gem 'devise'
gem 'devise-jwt'
gem 'jsonapi-serializer'
gem 'pundit'

# gema para buscar por filtros
gem 'ransack', '~> 4.2', '>= 4.2.1'

gem 'puma_worker_killer'
# gema para cargar las variables de entorno
gem 'dotenv-rails', groups: [:development, :test, :production]

# gema para agrupar por fechas
gem 'groupdate'
