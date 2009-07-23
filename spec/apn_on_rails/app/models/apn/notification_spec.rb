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
      
      rsa_mock = mock('rsa_mock')
      OpenSSL::PKey::RSA.should_receive(:new).with(apn_cert, '').and_return(rsa_mock)

      cert_mock = mock('cert_mock')
      OpenSSL::X509::Certificate.should_receive(:new).and_return(cert_mock)

      ctx_mock = mock('ctx_mock')
      ctx_mock.should_receive(:key=).with(rsa_mock)
      ctx_mock.should_receive(:cert=).with(cert_mock)
      OpenSSL::SSL::SSLContext.should_receive(:new).and_return(ctx_mock)

      # TCPSocket.new(configatron.apn.host, configatron.apn.port)
      tcp_mock = mock('tcp_mock')
      tcp_mock.should_receive(:close)
      TCPSocket.should_receive(:new).with('gateway.sandbox.push.apple.com', 2195).and_return(tcp_mock)
      
      ssl_mock = mock('ssl_mock')
      ssl_mock.should_receive(:sync=).with(true)
      ssl_mock.should_receive(:connect)
      ssl_mock.should_receive(:write).with('message-0')
      ssl_mock.should_receive(:write).with('message-1')
      ssl_mock.should_receive(:close)
      OpenSSL::SSL::SSLSocket.should_receive(:new).with(tcp_mock, ctx_mock).and_return(ssl_mock)
      
      APN::Notification.send_notifications(notifications)
      
    end
    
  end
  
end