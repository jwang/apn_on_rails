class APN::Device < ActiveRecord::Base
  set_table_name 'apn_devices'
  
  has_many :notifications, :class_name => 'APN::Notification'
  
  validates_uniqueness_of :token
  
  def token=(token)
    res = token.scan(/\<(.+)\>/).first
    unless res.nil? || res.empty?
      # self.token = res.first
      token = res.first
    end
    write_attribute('token', token)
  end
  
  before_validation :clean_token
  
  private
  def clean_token
    if self.token && self.token_changed?
      res = self.token.scan(/\<(.+)\>/).first
      unless res.nil? || res.empty?
        self.token = res.first
      end
    end
  end
  
end