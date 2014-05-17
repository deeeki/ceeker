class Conversation::Tweet
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :conversation
end
