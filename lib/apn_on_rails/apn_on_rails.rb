require 'socket'
require 'openssl'
require 'configatron'

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