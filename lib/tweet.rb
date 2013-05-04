class Tweet
  include Mongoid::Document

  class << self
    def create_from_status status
      create({
        id: status.id,
        screen_name: status.user.screen_name,
        name: status.user.name,
        profile_image_url: status.user.profile_image_url,
        text: status.text,
        in_reply_to_status_id: status.in_reply_to_status_id,
        in_reply_to_user_id: status.in_reply_to_user_id,
        lang: status.lang,
        created_at: status.created_at,
      })
    end
  end
end
