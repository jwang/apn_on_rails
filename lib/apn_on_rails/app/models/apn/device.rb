class APN::Device < ActiveRecord::Base
  set_table_name 'apn_devices'
  
  has_many :notifications, :class_name => 'APN::Notification'
  
  validates_uniqueness_of :token
  validates_format_of :token, :with => /^[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}$/
  
  def token=(token)
    res = token.scan(/\<(.+)\>/).first
    unless res.nil? || res.empty?
      token = res.first
    end
    write_attribute('token', token)
  end
  
  def to_hexa
    [self.token.delete(' ')].pack('H*')
  end
  
end