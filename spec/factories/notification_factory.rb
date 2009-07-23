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

# t.integer :device_id, :null => false
# t.integer :errors_nb, :default => 0 # used for storing errors from apple feedbacks
# t.string :device_language, :size => 5 # if you don't want to send localized strings
# t.text :payload
# t.string :sound
# t.integer :badge
# t.text :app_data
# t.datetime :sent_at
# t.timestamps