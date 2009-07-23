require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'spec_helper.rb')

describe APN::Device do
  
  describe 'token' do
    
    it 'should be unique' do
      device = DeviceFactory.new(:token => APN::Device.first.token)
      device.should_not be_valid
      device.errors['token'].should include('has already been taken')
      
      device = DeviceFactory.new(:token => device.token.succ)
      device.should be_valid
    end
    
    it 'should get cleansed if it contains brackets' do
      token = DeviceFactory.random_token
      device = DeviceFactory.new(:token => "<#{token}>")
      device.token.should == token
      device.token.should_not == "<#{token}>"
    end
    
  end
  
end