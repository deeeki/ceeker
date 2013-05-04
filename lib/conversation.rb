class Conversation
  include Mongoid::Document
  embeds_many :tweets, class_name: 'Conversation::Tweet'

  class << self
    def create_with_tweets *tweets
      root_tweet_id = tweets.first.in_reply_to_status_id || tweets.first.id
      create({
        tweet_ids: tweets.map(&:id),
        tweets: tweets,
        tweet_count: tweets.size,
        root_tweet_id: root_tweet_id,
        lang: tweets.first.lang,
        length: tweets.map(&:text).join.length,
        start_at: tweets.first.created_at,
        end_at: tweets.last.created_at,
        created_at: Time.now,
      })
    end
  end

  def add tweet
    merged_tweets = [tweets, tweet].flatten
    update_attributes({
      tweet_ids: merged_tweets.map(&:id),
      tweets: merged_tweets,
      tweet_count: merged_tweets.size,
      length: merged_tweets.map(&:text).join.length,
      end_at: tweet.created_at,
    })
  end
end
