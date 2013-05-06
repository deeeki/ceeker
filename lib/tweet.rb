class Tweet
  PERMALINK_FORMAT = 'https://twitter.com/%s/status/%s'
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
        in_reply_to_screen_name: status.in_reply_to_screen_name,
        lang: status.lang,
        created_at: status.created_at,
      })
    end
  end

  def replied?
    !!in_reply_to_status_id
  end

  def permalink
    PERMALINK_FORMAT % [screen_name, id]
  end

  def replied_permalink
    return nil unless replied?
    PERMALINK_FORMAT % [in_reply_to_screen_name, in_reply_to_status_id]
  end
end
