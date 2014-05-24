require 'bundler/setup'
Bundler.require(:default, :web, ENV['RACK_ENV'] || :development)

require File.expand_path('../app', __FILE__)
Sprockets.append_path(File.expand_path('../assets/javascripts', __FILE__))
Sprockets.append_path(File.expand_path('../assets/stylesheets', __FILE__))
Sprockets.append_path("#{Bundler.load.specs['jquery-rails'].first.gem_dir}/vendor/assets/javascripts")
Sprockets.append_path("#{Bundler.load.specs['bootstrap-sass'].first.gem_dir}/vendor/assets/javascripts")
Sprockets.append_path("#{Bundler.load.specs['bootstrap-sass'].first.gem_dir}/vendor/assets/stylesheets")

map '/assets' do
  environment = Sprockets::Environment.new
  environment.context_class.class_eval do
    def asset_path path, options = {}
      path
    end
  end
  run environment
end

map '/' do
  run App
end
