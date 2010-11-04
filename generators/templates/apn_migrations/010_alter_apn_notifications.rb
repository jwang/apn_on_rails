class AlterApnNotifications < ActiveRecord::Migration # :nodoc:
  
  def self.up
    unless APN::Notification.column_names.include?("custom_properties")
      add_column :apn_notifications, :custom_properties, :text
    end
  end

  def self.down
    if APN::Notification.column_names.include?("custom_properties")
      remove_column :apn_notifications, :custom_properties
    end
  end
  
end