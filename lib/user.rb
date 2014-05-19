class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Updated

  class << self
    def save_from_api api_user
      user = find_or_initialize_by(id: api_user.id)
      user.update_attributes({
        screen_name:       api_user.screen_name,
        name:              api_user.name,
        description:       api_user.description,
        location:          api_user.location,
        website:           api_user.website.to_s,
        profile_image_url: api_user.profile_image_url.to_s,
        tweets_count:      api_user.tweets_count,
        friends_count:     api_user.friends_count,
        followers_count:   api_user.followers_count,
        favorites_count:   api_user.favorites_count,
        listed_count:      api_user.listed_count,
        lang:              api_user.lang,
        time_zone:         api_user.time_zone,
        utc_offset:        api_user.utc_offset,
        connections:       api_user.connections,
        created_at:        api_user.created_at,
      })
    end
  end
end
