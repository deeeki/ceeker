require 'bundler/setup'
Bundler.require(:default, :mail)

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)

require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)

Sprockets.append_path(File.expand_path('../assets/stylesheets', __FILE__))

ActionMailer::Base.append_view_path(File.expand_path('../views', __FILE__))
ActionMailer::Base.smtp_settings = {
  :address        => ENV['MAILGUN_SMTP_SERVER'],
  :port           => ENV['MAILGUN_SMTP_PORT'],
  :domain         => 'heroku.com',
  :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
  :password       => ENV['MAILGUN_SMTP_PASSWORD'],
  :authentication => :plain,
}

require 'action_dispatch/http/mime_type'
ActionView::Template::Types.delegate_to(Mime) # neccesary to detect appropriate Content-Type

Temple::Templates::Rails(Slim::Engine, register_as: :slim)

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

to_time = eval(ARGV.first || 'Time.now') rescue Time.now
AppMailer.hourly(to_time).deliver
