class App < Sinatra::Base
  configure do
    require 'cgi'
    Dotenv.load
    Mongoid.load!("#{settings.root}/config/mongoid.yml", :production)
    ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)
    enable :sessions
  end

  helpers Twitter::Autolink
  helpers do
    def current_page
      (params[:page] || 1).to_i
    end
  end

  error do
    halt 404
  end

  not_found do
    slim :not_found
  end

  before do
    session[:lang] = params[:lang].empty? ? nil : params[:lang] if params[:lang]
    @lang = session[:lang]
  end

  get '/' do
    @conversations = Conversation.order(ended_at: :desc).lang(@lang).page(current_page, 50)
    slim :index, layout: !request.xhr?
  end

  get %r[\A/(\d{4})/(\d{2})/(\d{2})\z] do |year, month, day|
    @date = Date.new(year.to_i, month.to_i, day.to_i)
    @conversations = Conversation.during_day_on(@date).lang(@lang).by_priority.page(current_page, 50)
    slim :index, layout: !request.xhr?
  end
end
