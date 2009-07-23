class APN::Notification < ActiveRecord::Base
  set_table_name 'apn_notifications'
  
  belongs_to :device, :class_name => 'APN::Device'
  
  def apple_hash
    result = {}
    result['aps'] = {}
    result['aps']['alert'] = self.alert if self.alert
    result['aps']['badge'] = self.badge.to_i if self.badge
    if self.sound
      result['aps']['sound'] = self.sound if self.sound.is_a? String
      result['aps']['sound'] = "1.aiff" if self.sound.is_a?(TrueClass)
    end
    result
  end
  
end