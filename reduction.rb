require 'bundler/setup'
Bundler.require(:default, :process)

Dotenv.load

Mongoid.load!('config/mongoid.yml', ENV['RACK_ENV'] || :development)

ActiveSupport::Dependencies.autoload_paths << File.expand_path('../lib', __FILE__)

stats = Mongoid.default_session.command(dbStats: 1)
exit if stats['fileSize'] < 500000000 # MongoLab limit is 520093696

Tweet.lt(id: Tweet.skip(15000).first.id).delete_all
Conversation.lt(id: Conversation.skip(1500).first.id).delete_all

Mongoid.default_session.command(repairDatabase: 1)
