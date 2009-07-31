class AddRegisteredAtToApnDevices < ActiveRecord::Migration # :nodoc:
  
  module APN
    class Device < ActiveRecord::Base
      set_table_name 'apn_devices'
    end
  end
  
  def self.up
    add_column :apn_devices, :last_registered_at, :datetime
    
    APN::Device.all.each do |device|
      device.last_registered_at = device.created_at
      device.save!
    end
    
  end

  def self.down
    remove_column :apn_devices, :last_registered_at
  end
end
