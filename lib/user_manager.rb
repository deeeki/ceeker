class UserManager
  class << self
    def client
      @client ||= Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['CONSUMER_KEY']
        config.consumer_secret = ENV['CONSUMER_SECRET']
        config.access_token = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
      end
    end

    def save *screen_names
      screen_names = screen_names.flatten
      return [] if screen_names.empty?
      client.users(screen_names).map do |api_user|
        User.save_from_api(api_user)
      end
    end

    def delete *screen_names
      screen_names = screen_names.flatten
      return 0 if screen_names.empty?
      User.any_in(screen_name: screen_names).delete_all
    end
  end
end
