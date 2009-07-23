module NotificationFactory
  
  class << self
    
    def new(options = {})
      device = APN::Device.first
      options = {:device_id => device.id, :sound => 'my_sound.aiff',
                 :badge => 5, :alert => 'Hello!'}.merge(options)
      return APN::Notification.new(options)
    end
    
    def create(options = {})
      notification = NotificationFactory.new(options)
      notification.save
      return notification
    end
    
  end
  
end

NotificationFactory.create