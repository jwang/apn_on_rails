module APN
  # Module for talking to the Apple Feedback Service.
  # The service is meant to let you know when a device is no longer
  # registered to receive notifications for your application.
  module Feedback
    
    class << self
      
      # Returns an Array of APN::Device objects that
      # has received feedback from Apple. Each APN::Device will
      # have it's <tt>feedback_at</tt> accessor marked with the time
      # that Apple believes the device de-registered itself.
      def devices(cert, &block)
        devices = []
        return if cert.nil? 
        APN::Connection.open_for_feedback({:cert => cert}) do |conn, sock|          
          while line = conn.read(38)   # Read 38 bytes from the SSL socket
            feedback = line.unpack('N1n1H140')            
            token = feedback[2].scan(/.{0,8}/).join(' ').strip
            device = APN::Device.find(:first, :conditions => {:token => token})
            if device
              device.feedback_at = Time.at(feedback[0])
              devices << device
            end
          end
        end
        devices.each(&block) if block_given?
        return devices
      end # devices
      
      def process_devices
        ActiveSupport::Deprecation.warn("The method APN::Feedback.process_devices is deprecated.  Use APN::App.process_devices instead.")
        APN::App.process_devices
      end
      
    end # class << self
    
  end # Feedback
end # APN