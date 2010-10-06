class CreateGroups < ActiveRecord::Migration # :nodoc:
  def self.up
    create_table :apn_groups do |t|
      t.column :name, :string
    
      t.timestamps
    end
    
    create_table :apn_devices_apn_groups, :id => false do |t|
      t.column :group_id, :integer
      t.column :device_id, :integer
    end
    
    add_index :apn_devices_apn_groups, [:group_id, :device_id]
    add_index :apn_devices_apn_groups, :device_id
    add_index :apn_devices_apn_groups, :group_id
  end 
  
  def self.down
    drop_table :apn_groups
    drop_table :apn_devices_apn_groups
  end
end