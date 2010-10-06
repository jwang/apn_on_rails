class APN::Group < APN::Base
  
  belongs_to :app, :class_name => 'APN::App'
  has_many   :device_groupings, :class_name => "APN::DeviceGrouping", :dependent => :destroy
  has_many   :devices, :class_name => 'APN::Device', :through => :device_groupings
  has_many   :group_notifications, :class_name => 'APN::GroupNotification'
  has_many   :unsent_group_notifications, :class_name => 'APN::GroupNotification', :conditions => 'sent_at is null'
  
  validates_presence_of :app_id
  validates_uniqueness_of :name, :scope => :app_id
    
end