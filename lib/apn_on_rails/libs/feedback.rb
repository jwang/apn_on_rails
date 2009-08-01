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
      def devices(&block)
        devices = []
        APN::Connection.open_for_feedback do |conn, sock|
          while line = sock.gets   # Read lines from the socket
            line.strip!
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
      
      # Retrieves a list of APN::Device instnces from Apple using
      # the <tt>devices</tt> method. It then checks to see if the
      # <tt>last_registered_at</tt> date of each APN::Device is
      # before the date that Apple says the device is no longer
      # accepting notifications then the device is deleted. Otherwise
      # it is assumed that the application has been re-installed
      # and is available for notifications.
      # 
      # This can be run from the following Rake task:
      #   $ rake apn:feedback:process
      def process_devices
        APN::Feedback.devices.each do |device|
          if device.last_registered_at < device.feedback_at
            device.destroy
          end
        end
      end # process_devices
      
    end # class << self
    
  end # Feedback
end # APN