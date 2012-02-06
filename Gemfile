source 'http://rubygems.org'

gem 'rails', '~> 3.2.1'
gem "rails-backbone"
gem 'jquery-rails' 

gem 'pg'
gem 'formtastic', '>=2.0.2'
gem 'workflow'
gem 'carrierwave', :git=>'git://github.com/jnicklas/carrierwave.git'
gem 'chronic'

gem 'devise'

#gem 'resque', :require => "resque/server"
gem 'qu-redis'

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
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'shoulda-matchers'
  gem 'rspec-rails' #, :git=>'git://github.com/rspec/rspec-rails.git'
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "cucumber-rails"
  gem "capybara"
  gem "launchy"
  gem 'railroady'
end

group :test do
  gem 'sqlite3'
end

group :production do
  gem 'SyslogLogger', :require => 'syslog_logger'
end
