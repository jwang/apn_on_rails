class APN::Notification < ActiveRecord::Base
  set_table_name 'apn_notifications'
  
  belongs_to :device, :class_name => 'APN::Device'
  
end