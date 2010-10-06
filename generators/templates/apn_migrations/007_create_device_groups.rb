class CreateDeviceGroups < ActiveRecord::Migration # :nodoc:
  def self.up
    drop_table :apn_devices_apn_groups
    
    create_table :apn_device_groupings do |t|
      t.column :group_id, :integer
      t.column :device_id, :integer
    end
    
    add_index :apn_device_groupings, [:group_id, :device_id]
    add_index :apn_device_groupings, :device_id
    add_index :apn_device_groupings, :group_id
  end 
  
  def self.down
    drop_table :apn_device_groupings
  
    create_table :apn_devices_apn_groups, :id => false do |t|
      t.column :group_id, :integer
      t.column :device_id, :integer
    end
    
    add_index :apn_devices_apn_groups, [:group_id, :device_id]
    add_index :apn_devices_apn_groups, :device_id
    add_index :apn_devices_apn_groups, :group_id
  end
end