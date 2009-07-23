namespace :apn do
  
  namespace :notifications do
    
    desc "Deliver all unsent APN notifications."
    task :deliver => [:environment] do
      notifications = APN::Notification.all(:conditions => {:sent_at => nil})
      unless notifications.empty?
        include ActionView::Helpers::TextHelper
        RAILS_DEFAULT_LOGGER.info "APN: Attempting to deliver #{pluralize(notifications.size, 'notification')}."
        APN::Notification.send_notifications(notifications)
      end
    end
    
  end # notifications
  
end # apn