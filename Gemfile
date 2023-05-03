# frozen_string_literal: true

source "https://rubygems.org"

gem "backbone-rails"
gem "jquery-rails"
gem "rails", "~> 5.2"
gem "rake"

gem "carrierwave" # , :git => "git://github.com/carrierwaveuploader/carrierwave.git"
gem "chronic"
gem "pg"

gem "simple_form"
gem "workflow-activerecord", ">= 4.1", "< 6.0"

gem "active_model_serializers"
gem "devise"

gem "uuid"

gem "roo", "=2.8.3"
gem "roo-xls"

gem "i18n", "=1.8.2"

gem "redis-rails"

# gem "resque", :require => "resque/server"
gem "qu-redis"

# To use ActiveModel has_secure_password
gem "bcrypt"

gem "dalli", group: :production
gem "prometheus-client"

# Use unicorn as the web server
gem "unicorn", group: :production

gem "rb-readline"

gem "listen"

# gem "concurrent-ruby"

group :development do
  gem "bcrypt_pbkdf"

  gem "capistrano3-unicorn"
  gem "capistrano-bundler"
  gem "capistrano-rails"

  gem "ed25519"
  gem "net-ssh"
  gem "rbnacl", "< 5.0"
  gem "rbnacl-libsodium"
end

# Gems used only for assets and not required
# in production environments by default.
# group :assets do
gem "bootstrap-sass"
gem "coffee-rails"
gem "sass-rails", ">= 3.2"
# gem "therubyracer", require: "v8"
gem "uglifier"
# end

group :test, :development do
  # gem "jasmine-rails"
  gem "rspec-rails"
  gem "puma"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "launchy"
  gem "shoulda-matchers"
end
