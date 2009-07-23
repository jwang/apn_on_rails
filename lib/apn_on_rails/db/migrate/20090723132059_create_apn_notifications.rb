class CreateApnNotifications < ActiveRecord::Migration
  
  def self.up

    create_table :apn_notifications do |t|
      t.integer :device_id, :null => false
      t.integer :errors_nb, :default => 0 # used for storing errors from apple feedbacks
      t.string :device_language, :size => 5 # if you don't want to send localized strings
      t.text :payload
      t.string :sound
      t.integer :badge
      t.text :app_data
      t.datetime :sent_at
      t.timestamps
    end
    
    add_index :apn_notifications, :device_id
  end

  def self.down
    drop_table :apn_notifications
  end
  
end

# add_column :apple_push_notifications, :payload, :text
# add_column :apple_push_notifications, :sound, :string
# add_column :apple_push_notifications, :badge, :integer
# add_column :apple_push_notifications, :alert, :string
# add_column :apple_push_notifications, :appdata, :text
# add_column :apple_push_notifications, :sent_at, :datetime
# add_column :apple_push_notifications, :device_id, :integer