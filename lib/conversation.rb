class Conversation
  include Mongoid::Document
  embeds_many :tweets, class_name: 'Conversation::Tweet'
end
