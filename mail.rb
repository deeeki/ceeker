require 'bundler/setup'
Bundler.require(:default, :mail)

@from = eval(ARGV.first || '1.hour.ago') rescue 1.hour.ago

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)

require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)

Sprockets.append_path(File.expand_path('../assets/stylesheets', __FILE__))

require 'action_dispatch/http/mime_type'
ActionView::Template::Types.delegate_to Mime
ActionMailer::Base.append_view_path(File.expand_path('../views', __FILE__))

require 'ostruct'
Roadie.class_eval do
  def self.app
    @app ||= OpenStruct.new(
      assets: Sprockets::Environment.new do |env|
        env.context_class.class_eval do
          def asset_path path, options = {}
            path
          end
        end
      end,
      config: OpenStruct.new(
        roadie: OpenStruct.new(
          enabled: true,
          provider: Roadie::AssetPipelineProvider.new,
        )
      )
    )
  end
end

require 'roadie/action_mailer_extensions'
ActionMailer::Base.__send__(:include, Roadie::ActionMailerExtensions)

AppMailer.hourly(@from).deliver
