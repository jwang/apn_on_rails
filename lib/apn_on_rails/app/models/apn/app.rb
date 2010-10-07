class APN::App < APN::Base
  
  has_many :groups, :class_name => 'APN::Group', :dependent => :destroy
  has_many :devices, :class_name => 'APN::Device', :dependent => :destroy
  has_many :notifications, :through => :devices, :dependent => :destroy
  has_many :unsent_notifications, :through => :devices
  has_many :group_notifications, :through => :groups
  has_many :unsent_group_notifications, :through => :groups
    
  def cert
    (RAILS_ENV == 'production' ? apn_prod_cert : apn_dev_cert)
  end
  
  # Opens a connection to the Apple APN server and attempts to batch deliver
  # an Array of group notifications.
  # 
  # 
  # As each APN::GroupNotification is sent the <tt>sent_at</tt> column will be timestamped,
  # so as to not be sent again.
  # 
  def send_notifications
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
    unless self.unsent_notifications.nil? || self.unsent_notifications.empty?
      APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
        unsent_notifications.each do |noty|
          conn.write(noty.message_for_sending)
          noty.sent_at = Time.now
          noty.save
        end
      end
    end
  end
  
  def self.send_notifications
    apps = APN::App.all 
    apps.each do |app|
      app.send_notifications
    end
  end
  
  def send_group_notifications
    if self.cert.nil? 
      raise APN::Errors::MissingCertificateError.new
      return
    end
    unless self.unsent_group_notifications.nil? || self.unsent_group_notifications.empty? 
      APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
        unsent_group_notifications.each do |gnoty|
          puts "number of devices is #{gnoty.devices.size}"
          gnoty.devices.each do |device|
            conn.write(gnoty.message_for_sending(device))
          end
          gnoty.sent_at = Time.now
          gnoty.save
        end
      end
    end
  end
  
  def send_group_notification(gnoty)
    if self.cert.nil? 
      raise APN::Errors::MissingCertificateError.new
      return
    end
    unless gnoty.nil?
      APN::Connection.open_for_delivery({:cert => self.cert}) do |conn, sock|
        gnoty.devices.each do |device|
          conn.write(gnoty.message_for_sending(device))
        end
        gnoty.sent_at = Time.now
        gnoty.save
      end
    end
  end
  
  def self.send_group_notifications
    apps = APN::App.all
    apps.each do |app|
      app.send_group_notifications
    end
  end          
  
  # Retrieves a list of APN::Device instnces from Apple using
  # the <tt>devices</tt> method. It then checks to see if the
  # <tt>last_registered_at</tt> date of each APN::Device is
  # before the date that Apple says the device is no longer
  # accepting notifications then the device is deleted. Otherwise
  # it is assumed that the application has been re-installed
  # and is available for notifications.
  # 
  # This can be run from the following Rake task:
  #   $ rake apn:feedback:process
  def process_devices
    if self.cert.nil?
      raise APN::Errors::MissingCertificateError.new
      return
    end
    APN::Feedback.devices(self.cert).each do |device|
      if device.last_registered_at < device.feedback_at
        device.destroy
      end
    end
  end # process_devices
  
  def self.process_devices
    apps = APN::App.all
    apps.each do |app|
      app.process_devices
    end
  end
    
end