module PullNotificationFactory
  
  class << self
    
    def new(options = {})
      app = APN::App.first
      options = {:app_id => app.id, :title => 'Pull Notification Title', 
                 :content => 'blah blah blah', :link => 'http://www.prx.org', :launch_notification => false}.merge(options)
      return APN::PullNotification.new(options)
    end
    
    def create(options = {})
      noty = PullNotificationFactory.new(options)
      noty.save
      return noty
    end
    
  end
  
end

PullNotificationFactory.create