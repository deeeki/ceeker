source 'https://rubygems.org'

ruby '2.1.2'

gem 'activesupport', require: 'active_support'
gem 'mongoid', github: 'mongoid/mongoid'
gem 'dotenv'

group :worker do
  gem 'tweetstream'
end

group :mail do
  gem 'actionmailer', require: 'action_mailer'
  gem 'roadie'
end

group :mail, :web do
  gem 'slim'
  gem 'sass'
  gem 'sprockets'
  gem 'twitter-text'
end

group :web do
  gem 'sinatra'
  gem 'bootstrap-sass', require: false
  gem 'flat-ui-rails', require: false
end

group :development do
  gem 'guard-pow'
  gem 'letter_opener'
end
