class MakeDeviceTokenIndexNonunique < ActiveRecord::Migration
  def self.up
    remove_index :apn_devices, :column => :token
    add_index :apn_devices, :token
  end

  def self.down
    remove_index :apn_devices, :column => :token
    add_index :apn_devices, :token, :unique => true
  end
end
