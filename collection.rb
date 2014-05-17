require 'bundler/setup'
Bundler.require(:default, :worker)

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)

TweetStream.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.consumer_secret = ENV['CONSUMER_SECRET']
  config.oauth_token = ENV['ACCESS_TOKEN']
  config.oauth_token_secret = ENV['ACCESS_TOKEN_SECRET']
  config.auth_method = :oauth
end

require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)

def save(status)
  EM.defer do
    tweet = Tweet.create_from_status(status)

    next unless status.in_reply_to_status_id
    next unless src_tweet = Tweet.find_by(id: status.in_reply_to_status_id)

    if conversation = Conversation.find_by(tweet_ids: src_tweet.id)
      conversation.add(tweet)
    else
      Conversation.create_with_tweets(src_tweet, tweet)
    end
  end
rescue => e
  puts e
end

@client = TweetStream::Client.new
@client.follow(ENV['USER_IDS']) do |status|
  next unless status.text
  next if status.retweeted?
  next if status.text =~ /^RT /
  next if status.user.protected?

  save(status)
end
