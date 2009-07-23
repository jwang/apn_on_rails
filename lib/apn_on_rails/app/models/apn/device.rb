class APN::Device < ActiveRecord::Base
  set_table_name 'apn_devices'
  
  has_many :notifications, :class_name => 'APN::Notification'
  
  validates_uniqueness_of :token
  validates_format_of :token, :with => /^[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}\s[a-z0-9]{8}$/
  
  # If the token comes in like this:
  #  '<5gxadhy6 6zmtxfl6 5zpbcxmw ez3w7ksf qscpr55t trknkzap 7yyt45sc g6jrw7qz>'
  # Then the '<' and '>' will be stripped off.
  def token=(token)
    res = token.scan(/\<(.+)\>/).first
    unless res.nil? || res.empty?
      token = res.first
    end
    write_attribute('token', token)
  end
  
  # Returns the hexadecimal representation of the device's token.
  def to_hexa
    [self.token.delete(' ')].pack('H*')
  end
  
end