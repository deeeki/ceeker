class Conversation::Tweet
  include Mongoid::Document
  embedded_in :conversation
end
