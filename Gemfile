source 'http://rubygems.org'

gem 'rails', '~> 3.2.0.rc'
gem "rails-backbone"
gem 'jquery-rails' 

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'formtastic', '>=2.0.2'
gem 'workflow'
gem 'carrierwave'
#gem 'spreadsheet'

gem 'devise'
#gem 'oa-openid', :require => 'omniauth/openid'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'execjs'
  gem 'therubyracer'

  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# Use unicorn as the web server
gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

group :test, :development do
  gem 'shoulda-matchers'
  gem 'rspec-rails'
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "cucumber-rails"
  gem "capybara"
  gem "launchy"
end

group :test do
  gem 'sqlite3'
end
