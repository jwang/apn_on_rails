require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'spec_helper.rb')

describe APN::Notification do
  
  describe 'alert' do
    
    it 'should trim the message to 150 characters' do
      noty = APN::Notification.new
      noty.alert = 'a' * 200
      noty.alert.should == ('a' * 147) + '...'
    end
    
  end
  
  describe 'apple_hash' do
    
    it 'should return a hash of the appropriate params for Apple' do
      noty = APN::Notification.first
      noty.apple_hash.should == {"aps" => {"badge" => 5, "sound" => "my_sound.aiff", "alert" => "Hello!"}}
      noty.badge = nil
      noty.apple_hash.should == {"aps" => {"sound" => "my_sound.aiff", "alert" => "Hello!"}}
      noty.alert = nil
      noty.apple_hash.should == {"aps" => {"sound" => "my_sound.aiff"}}
      noty.sound = nil
      noty.apple_hash.should == {"aps" => {}}
      noty.sound = true
      noty.apple_hash.should == {"aps" => {"sound" => "1.aiff"}}
    end
    
  end
  
  describe 'to_apple_json' do
    
    it 'should return the necessary JSON for Apple' do
      noty = APN::Notification.first
      noty.to_apple_json.should == %{{"aps":{"badge":5,"sound":"my_sound.aiff","alert":"Hello!"}}}
    end
    
  end
  
  describe 'message_for_sending' do
    
    it 'should create a binary message to be sent to Apple' do
      noty = APN::Notification.first
      noty.device = DeviceFactory.new(:token => '5gxadhy6 6zmtxfl6 5zpbcxmw ez3w7ksf qscpr55t trknkzap 7yyt45sc g6jrw7qz')
      noty.message_for_sending.should == fixture_value('message_for_sending.bin')
    end
    
    it 'should raise an APN::Errors::ExceededMessageSizeError if the message is too big' do
      noty = NotificationFactory.new(:device_id => DeviceFactory.create, :sound => true, :badge => nil)
      noty.send(:write_attribute, 'alert', 'a' * 183)
      lambda {
        noty.message_for_sending
      }.should raise_error(APN::Errors::ExceededMessageSizeError)
    end
    
  end
  
  describe 'send_notifications' do
    
    it 'should send the notifications in an Array' do
      
      notifications = [NotificationFactory.create, NotificationFactory.create]
      notifications.each_with_index do |notify, i|
        notify.stub(:message_for_sending).and_return("message-#{i}")
        notify.should_receive(:sent_at=).with(instance_of(Time))
        notify.should_receive(:save)
      end
      
      ssl_mock = mock('ssl_mock')
      ssl_mock.should_receive(:write).with('message-0')
      ssl_mock.should_receive(:write).with('message-1')
      APN::Connection.should_receive(:open_for_delivery).and_yield(ssl_mock, nil)
      
      APN::Notification.send_notifications(notifications)
      
    end
    
  end
  
end