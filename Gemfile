source 'https://rubygems.org'

group :web do
  gem 'sinatra'
  gem 'bootstrap-sass', require: false
  gem 'flat-ui-rails', require: false
end

group :mail do
  gem 'actionmailer', '4.0.0.rc1', require: 'action_mailer'
  gem 'roadie', github: 'Mange/roadie'
end

group :process do
  gem 'tweetstream'
end

group :web, :mail do
  gem 'slim'
  gem 'sass'
  gem 'sprockets'
  gem 'twitter-text'
end

group :mail, :process do
  gem 'dotenv'
end

group :development do
  gem 'guard-pow'
end

gem 'mongoid', github: 'mongoid/mongoid'
gem 'bson_ext'
gem 'activesupport', '4.0.0.rc1', require: false
