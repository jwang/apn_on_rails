class CreateApnNotifications < ActiveRecord::Migration # :nodoc:
  
  def self.up

    create_table :apn_notifications do |t|
      t.integer :device_id, :null => false
      t.integer :errors_nb, :default => 0 # used for storing errors from apple feedbacks
      t.string :device_language, :size => 5 # if you don't want to send localized strings
      t.string :sound
      t.string :alert, :size => 150
      t.integer :badge
      t.datetime :sent_at
      t.timestamps
    end
    
    add_index :apn_notifications, :device_id
  end

  def self.down
    drop_table :apn_notifications
  end
  
end