require 'bundler/setup'
Bundler.require

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)

stats = Mongoid.default_session.command(dbStats: 1)
exit if stats['fileSize'] < 500000000 # MongoLab limit is 520093696

Tweet.lt(id: Tweet.skip(50000).first.id).delete_all
Conversation.lt(id: Conversation.skip(5000).first.id).delete_all

Mongoid.default_session.command(repairDatabase: 1)
new_stats = Mongoid.default_session.command(dbStats: 1)

puts <<EOH
Reduction result
     dataSize: #{stats['dataSize']} -> #{new_stats['dataSize']}
  storageSize: #{stats['storageSize']} -> #{new_stats['storageSize']}
     fileSize: #{stats['fileSize']} -> #{new_stats['fileSize']}
EOH
