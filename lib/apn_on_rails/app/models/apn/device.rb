class APN::Device < ActiveRecord::Base
  set_table_name 'apn_devices'
  
  has_many :notifications, :class_name => 'APN::Notification'
  
  validates_uniqueness_of :token
  
  def token=(token)
    res = token.scan(/\<(.+)\>/).first
    unless res.nil? || res.empty?
      token = res.first
    end
    write_attribute('token', token)
  end
  
end