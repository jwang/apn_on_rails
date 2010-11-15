class AddLaunchNotificationToApnPullNotifications < ActiveRecord::Migration
  def self.up
    add_column :apn_pull_notifications, :launch_notification, :boolean
  end

  def self.down
    remove_column :apn_pull_notifications, :launch_notification
  end
end