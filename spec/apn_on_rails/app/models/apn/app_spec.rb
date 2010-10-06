require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'spec_helper.rb')

describe APN::App do

  describe 'send_notifications' do
  
    it 'should send the unsent notifications' do
    
      app = AppFactory.create
      device = DeviceFactory.create({:app_id => app.id})
      notifications = [NotificationFactory.create({:device_id => device.id}), 
                       NotificationFactory.create({:device_id => device.id})]
      notifications.each_with_index do |notify, i|
        notify.stub(:message_for_sending).and_return("message-#{i}")
        notify.should_receive(:sent_at=).with(instance_of(Time))
        notify.should_receive(:save)
      end
    
      APN::App.should_receive(:all).and_return([app])
      app.should_receive(:unsent_notifications).at_least(:once).and_return(notifications)
      app.should_receive(:cert).twice.and_return(app.apn_dev_cert)
      
      ssl_mock = mock('ssl_mock')
      ssl_mock.should_receive(:write).with('message-0')
      ssl_mock.should_receive(:write).with('message-1')
      APN::Connection.should_receive(:open_for_delivery).and_yield(ssl_mock, nil)
    
      APN::App.send_notifications
    
    end
  
  end
  
  describe 'send_group_notifications' do
  
    it 'should send the unsent group notifications' do
    
      app = AppFactory.create
      device = DeviceFactory.create({:app_id => app.id})
      group =   GroupFactory.create({:app_id => app.id})
      device_grouping = DeviceGroupingFactory.create({:group_id => group.id,:device_id => device.id})
      puts "device grouping group is #{device_grouping.group.id} device grouping device is #{device_grouping.device.id}"
      gnotys = [GroupNotificationFactory.create({:group_id => group}), 
                GroupNotificationFactory.create({:group_id => group})]
      gnotys.each_with_index do |gnoty, i|
        gnoty.stub(:message_for_sending).at_least(:once).with(device).and_return("message-#{i}")
        gnoty.should_receive(:sent_at=).with(instance_of(Time))
        gnoty.should_receive(:save)
      end
    
      APN::App.should_receive(:all).and_return([app])
      app.should_receive(:unsent_group_notifications).at_least(:once).and_return(gnotys)
      app.should_receive(:cert).twice.and_return(app.apn_dev_cert)
      
      ssl_mock = mock('ssl_mock')
      ssl_mock.should_receive(:write).with('message-0')
      ssl_mock.should_receive(:write).with('message-1')
      APN::Connection.should_receive(:open_for_delivery).and_yield(ssl_mock, nil)
    
      APN::App.send_group_notifications
    
    end
  
  end
  
  describe 'nil cert when sending notifications' do 
    
    it 'should raise an exception for sending notifications for an app with no cert' do
      app = AppFactory.create
      APN::App.should_receive(:all).and_return([app])
      app.should_receive(:cert).and_return(nil)
      lambda { 
        APN::App.send_notifications
      }.should raise_error(APN::Errors::MissingCertificateError)
    end
    
  end
  
  describe 'process_devices' do
    
    it 'should destroy devices that have a last_registered_at date that is before the feedback_at date' do
      app = AppFactory.create
      devices = [DeviceFactory.create(:app_id => app.id, :last_registered_at => 1.week.ago, :feedback_at => Time.now),
                 DeviceFactory.create(:app_id => app.id, :last_registered_at => 1.week.from_now, :feedback_at => Time.now)]
      APN::Feedback.should_receive(:devices).and_return(devices)
      APN::App.should_receive(:all).and_return([app])
      app.should_receive(:cert).twice.and_return(app.apn_dev_cert)
      lambda {
        APN::App.process_devices
      }.should change(APN::Device, :count).by(-1)
    end
    
  end
  
  describe 'nil cert when processing devices' do 
    
    it 'should raise an exception for processing devices for an app with no cert' do
      app = AppFactory.create
      APN::App.should_receive(:all).and_return([app])
      app.should_receive(:cert).and_return(nil)
      lambda { 
        APN::App.process_devices
      }.should raise_error(APN::Errors::MissingCertificateError)
    end
    
  end
  
  describe 'cert for production environment' do 
    
    it 'should return the production cert for the app' do 
      app = AppFactory.create
      RAILS_ENV = 'production'
      app.cert.should == app.apn_prod_cert
    end
    
  end
  
  describe 'cert for development and staging environment' do 
    
    it 'should return the development cert for the app' do 
      app = AppFactory.create
      RAILS_ENV = 'staging'
      app.cert.should == app.apn_dev_cert
    end
  end

end