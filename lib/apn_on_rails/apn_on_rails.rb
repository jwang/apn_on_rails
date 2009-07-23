require 'socket'
require 'openssl'
require 'configatron'

rails_root = File.join(FileUtils.pwd, 'rails_root')
if defined?(RAILS_ROOT)
  rails_root = RAILS_ROOT
end

rails_env = 'development'
if defined?(RAILS_ENV)
  rails_env = RAILS_ENV
end

configatron.apn.set_default(:passphrase, '')
configatron.apn.set_default(:port, 2195)
configatron.apn.set_default(:host, 'gateway.sandbox.push.apple.com')
configatron.apn.set_default(:cert, File.join(rails_root, 'config', 'apple_push_notification_development.pem'))

if rails_env == 'production'
  configatron.apn.set_default(:host, 'gateway.push.apple.com')
  configatron.apn.set_default(:cert, File.join(rails_root, 'config', 'apple_push_notification_production.pem'))
end

module APN
  
  module Errors
    
    class ExceededMessageSizeError < StandardError
      
      def initialize(message)
        super("The maximum size allowed for a notification payload is 256 bytes: '#{message}'")
      end
      
    end
    
  end # Errors
  
end # APN

Dir.glob(File.join(File.dirname(__FILE__), 'app', 'models', 'apn', '*.rb')).sort.each do |f|
  require f
end

%w{ models controllers helpers }.each do |dir| 
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path 
  # puts "Adding #{path}"
  ActiveSupport::Dependencies.load_paths << path 
  ActiveSupport::Dependencies.load_once_paths.delete(path) 
end