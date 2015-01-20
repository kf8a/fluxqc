source 'http://rubygems.org'

gem 'rails', '~> 4.1'
gem 'backbone-on-rails'
gem 'jquery-rails' 

gem 'pg'
gem 'simple_form'
gem 'workflow'
gem 'carrierwave' #, :git=>'git://github.com/jnicklas/carrierwave.git'
gem 'chronic'

gem 'devise'
gem 'active_model_serializers'

gem 'uuid'

gem 'foreigner'

#gem 'resque', :require => "resque/server"
#gem 'qu-redis'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

# Use unicorn as the web server
gem 'unicorn', group: :production
gem 'dalli', group: :production

# Deploy with Capistrano
gem 'capistrano', '~> 2.15'

gem 'spring', group: :development

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer', :require => 'v8'

  gem 'sass-rails'
  gem 'less-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'twitter-bootstrap-rails'
end

group :test, :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'rspec-rails' 
  gem 'jasmine-rails'
end

group :test do
  gem 'sqlite3'
  gem 'shoulda-matchers'
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "capybara"
  gem "launchy"
  gem "cucumber-rails", require: false
end
