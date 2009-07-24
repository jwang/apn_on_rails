namespace :apn do
  
  namespace :notifications do
    
    desc "Deliver all unsent APN notifications."
    task :deliver => [:environment] do
      APN::Notification.send_notifications
    end
    
  end # notifications
  
end # apn