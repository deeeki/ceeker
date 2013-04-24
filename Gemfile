source 'https://rubygems.org'

group :web do
  gem 'sinatra'
  gem 'bootstrap-sass', require: false
  gem 'flat-ui-rails', require: false
end

group :mail do
  gem 'actionmailer', '4.0.0.beta1', require: 'action_mailer'
  gem 'roadie', github: 'Mange/roadie'
end

group :development, :mail do
  gem 'dotenv'
end

group :development do
  gem 'guard-pow'
end

gem 'mongoid', github: 'mongoid/mongoid'
gem 'bson_ext'
gem 'activesupport', '4.0.0.beta1', require: false
gem 'slim'
gem 'sass'
gem 'sprockets'
gem 'twitter-text'
