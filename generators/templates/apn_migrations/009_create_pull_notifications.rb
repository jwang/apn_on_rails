class CreatePullNotifications < ActiveRecord::Migration
  def self.up
    create_table :apn_pull_notifications do |t|
      t.integer :app_id
      t.string  :title
      t.string  :content
      t.string  :link

      t.timestamps
    end
  end

  def self.down
    drop_table :apn_pull_notifications
  end
end
