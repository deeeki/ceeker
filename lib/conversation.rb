class Conversation
  include Mongoid::Document
  embeds_many :tweets, class_name: 'Conversation::Tweet'

  scope :lang, ->(lang = 'ja'){ where(lang: lang) }
  scope :only_1hour, ->(to = Time.now){ where(:created_at.gte => to - 1.hour, :created_at.lt => to) }
  scope :by_priority, ->{ order_by(average_length: :desc) }

  class << self
    def create_with_tweets *tweets
      root_tweet_id = tweets.first.in_reply_to_status_id || tweets.first.id
      length = tweets.map(&:text).join.length
      create({
        tweet_ids: tweets.map(&:id),
        tweets: tweets,
        tweet_count: tweets.size,
        root_tweet_id: root_tweet_id,
        lang: tweets.first.lang,
        total_length: length,
        average_length: (length / tweets.size).to_i,
        start_at: tweets.first.created_at,
        end_at: tweets.last.created_at,
        created_at: Time.now,
      })
    end
  end

  def add tweet
    merged_tweets = [tweets, tweet].flatten
    length = merged_tweets.map(&:text).join.length
    update_attributes({
      tweet_ids: merged_tweets.map(&:id),
      tweets: merged_tweets,
      tweet_count: merged_tweets.size,
      total_length: length,
      average_length: (length / merged_tweets.size).to_i,
      end_at: tweet.created_at,
    })
  end
end
