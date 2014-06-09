class Conversation
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created
  embeds_many :tweets, class_name: 'Conversation::Tweet'

  scope :lang, ->(lang){ where(lang: lang) if lang }
  scope :page, ->(page, per = 50){ skip(((page || 1).to_i - 1) * per).limit(per) }
  scope :during_hour_to, ->(to = Time.now){ where(:ended_at.gte => to - 1.hour, :ended_at.lt => to) }
  scope :during_day_on, ->(on = Date.today){
    from = on.to_time.beginning_of_day
    where(:ended_at.gte => from, :ended_at.lte => from.end_of_day)
  }
  scope :desc_order_by, ->(attr){ order(attr => :desc) }

  class << self
    def create_with_tweets *tweets
      length = tweets.map(&:text).join.length
      create({
        tweet_ids: tweets.map(&:id),
        tweets: tweets,
        tweets_count: tweets.size,
        root_permalink: tweets.first.replied_permalink || tweets.first.permalink,
        lang: tweets.first.lang,
        total_length: length,
        average_length: (length / tweets.size).to_i,
        started_at: tweets.first.created_at,
        ended_at: tweets.last.created_at,
      })
    end
  end

  def add tweet
    merged_tweets = [tweets, tweet].flatten
    length = merged_tweets.map(&:text).join.length
    update_attributes({
      tweet_ids: merged_tweets.map(&:id),
      tweets: merged_tweets,
      tweets_count: merged_tweets.size,
      total_length: length,
      average_length: (length / merged_tweets.size).to_i,
      ended_at: tweet.created_at,
    })
  end
end
