require 'bundler/setup'
Bundler.require(:default, :mail, ENV['RACK_ENV'] || :development)

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)

Sprockets.append_path(File.expand_path('../assets/stylesheets', __FILE__))

ActionMailer::Base.append_view_path(File.expand_path('../views', __FILE__))
if defined?(LetterOpener)
  ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, location: File.expand_path('../tmp/letter_opener', __FILE__)
  ActionMailer::Base.delivery_method = :letter_opener
else
  ActionMailer::Base.smtp_settings = {
    :address        => ENV['MAILGUN_SMTP_SERVER'],
    :port           => ENV['MAILGUN_SMTP_PORT'],
    :domain         => 'heroku.com',
    :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :authentication => :plain,
  }
end

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

case ARGV[0]
when 'hour'
  time_to = eval(ARGV[1] || 'Time.now') rescue Time.now
  AppMailer.hour(time_to).deliver
else
  date = eval(ARGV[1] || 'Date.yesterday') rescue Date.yesterday
  AppMailer.day(date).deliver
end
