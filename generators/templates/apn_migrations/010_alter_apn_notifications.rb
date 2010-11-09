class AlterApnNotifications < ActiveRecord::Migration # :nodoc:
  
  module APN # :nodoc:
    class Notification < ActiveRecord::Base # :nodoc:
      set_table_name 'apn_notifications'
    end
  end
  
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