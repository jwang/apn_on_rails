namespace :apn do
  
  namespace :notifications do
    
    desc "Deliver all unsent APN notifications."
    task :deliver => [:environment] do
      APN::App.send_notifications
    end

  end # notifications

  namespace :group_notifications do 
    
    desc "Deliver all unsent APN Group notifications."
    task :deliver => [:environment] do
      APN::App.send_group_notifications
    end
    
  end # group_notifications
  
  namespace :feedback do
    
    desc "Process all devices that have feedback from APN."
    task :process => [:environment] do
      APN::App.process_devices
    end
    
  end
  
end # apn
