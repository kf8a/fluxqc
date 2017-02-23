source 'http://rubygems.org'

gem 'rails', '~> 4.2.7'
gem 'backbone-on-rails'
gem 'jquery-rails' 

gem 'pg'
gem 'simple_form'
gem 'workflow'
gem 'carrierwave'# , :git => 'git://github.com/carrierwaveuploader/carrierwave.git'
gem 'chronic'

gem 'devise'
gem 'active_model_serializers'

gem 'uuid'

gem 'foreigner'

gem 'roo'
gem 'roo-xls'

#gem 'resque', :require => "resque/server"
#gem 'qu-redis'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

gem 'prometheus-client', '~> 0.6.0'

# Use unicorn as the web server
gem 'unicorn', group: :production
gem 'dalli', group: :production

# Deploy with Capistrano
gem 'capistrano', '~> 2.15'

group :development do
  gem 'spring'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', :require => 'v8'
  #gem 'sass'
  gem 'bootstrap-sass', '~> 3.3.6'
  gem 'sass-rails', '>= 3.2'
  gem 'coffee-rails'
  gem 'uglifier'
  #gem 'twitter-bootstrap-rails'
end

group :test, :development do
  gem 'rspec-rails' 
  gem 'jasmine-rails'
end

group :test do
  gem 'shoulda-matchers'
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "capybara"
  gem "launchy"
  gem "cucumber-rails", require: false
end
