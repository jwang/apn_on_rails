module GroupNotificationFactory
  
  class << self
    
    def new(options = {})
      group = APN::Group.first
      options = {:group_id => group.id, :sound => 'my_sound.aiff',
                 :badge => 5, :alert => 'Hello!', :custom_properties => {'typ' => 1}}.merge(options)
      return APN::GroupNotification.new(options)
    end
    
    def create(options = {})
      notification = GroupNotificationFactory.new(options)
      notification.save
      return notification
    end
    
  end
  
end

GroupNotificationFactory.create