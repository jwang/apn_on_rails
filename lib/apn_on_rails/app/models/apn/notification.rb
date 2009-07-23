class APN::Notification < ActiveRecord::Base
  include ::ActionView::Helpers::TextHelper
  set_table_name 'apn_notifications'
  
  belongs_to :device, :class_name => 'APN::Device'
  
  def alert=(message)
    if !message.blank? && message.size > 150
      message = truncate(message, :length => 150)
    end
    write_attribute('alert', message)
  end
  
  # Creates a Hash that will be the payload of an APN.
  # 
  # Example:
  #   apn = APN::Notification.new
  #   apn.badge = 5
  #   apn.sound = 'my_sound.aiff'
  #   apn.alert = 'Hello!'
  #   apn.apple_hash # => {"aps" => {"badge" => 5, "sound" => "my_sound.aiff", "alert" => "Hello!"}}
  def apple_hash
    result = {}
    result['aps'] = {}
    result['aps']['alert'] = self.alert if self.alert
    result['aps']['badge'] = self.badge.to_i if self.badge
    if self.sound
      result['aps']['sound'] = self.sound if self.sound.is_a? String
      result['aps']['sound'] = "1.aiff" if self.sound.is_a?(TrueClass)
    end
    result
  end
  
  # Creates the JSON string required for an APN message.
  # 
  # Example:
  #   apn = APN::Notification.new
  #   apn.badge = 5
  #   apn.sound = 'my_sound.aiff'
  #   apn.alert = 'Hello!'
  #   apn.to_apple_json # => '{"aps":{"badge":5,"sound":"my_sound.aiff","alert":"Hello!"}}'
  def to_apple_json
    self.apple_hash.to_json
  end
  
  # Creates the binary message needed to send to Apple.
  def message_for_sending
    json = self.to_apple_json
    message = "\0\0 #{self.device.to_hexa}\0#{json.length.chr}#{json}"
    raise APN::Errors::ExceededMessageSizeError.new(message) if message.size.to_i > 256
    message
  end
  
  class << self
    
    def send_notifications(notifications)
      cert = File.read(configatron.apn.cert)
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.key = OpenSSL::PKey::RSA.new(cert, configatron.apn.passphrase)
      ctx.cert = OpenSSL::X509::Certificate.new(cert)
  
      s = TCPSocket.new(configatron.apn.host, configatron.apn.port)
      ssl = OpenSSL::SSL::SSLSocket.new(s, ctx)
      ssl.sync = true
      ssl.connect
  
      notifications.each do |noty|
        ssl.write(noty.message_for_sending)
        noty.sent_at = Time.now
        noty.save
      end
  
      ssl.close
      s.close
    end
    
  end # class << self
  
end # APN::Notification