require File.dirname(__FILE__) + '/../../spec_helper'

describe APN::Feedback do
  
  describe 'devices' do
    
    before(:each) do
      @time = Time.now
      @device = DeviceFactory.create
      
      @data_mock = mock('data_mock')
      @data_mock.should_receive(:strip!)
      @data_mock.should_receive(:unpack).with('N1n1H140').and_return([@time.to_i, 12388, @device.token.delete(' ')])
      
      @ssl_mock = mock('ssl_mock')
      @sock_mock = mock('sock_mock')
      @sock_mock.should_receive(:gets).twice.and_return(@data_mock, nil)
      
    end
    
    it 'should an Array of devices that need to be processed' do
      APN::Connection.should_receive(:open_for_feedback).and_yield(@ssl_mock, @sock_mock)
      
      devices = APN::Feedback.devices
      devices.size.should == 1
      r_device = devices.first
      r_device.token.should == @device.token
      r_device.feedback_at.to_s.should == @time.to_s
    end
    
    it 'should yield up each device' do
      APN::Connection.should_receive(:open_for_feedback).and_yield(@ssl_mock, @sock_mock)
      lambda {
        APN::Feedback.devices do |r_device|
          r_device.token.should == @device.token
          r_device.feedback_at.to_s.should == @time.to_s
          raise BlockRan.new
        end
      }.should raise_error(BlockRan)
    end
    
  end
  
  describe 'process_devices' do
    
    it 'should destroy devices that have a last_registered_at date that is before the feedback_at date' do
      devices = [DeviceFactory.create(:last_registered_at => 1.week.ago, :feedback_at => Time.now),
                 DeviceFactory.create(:last_registered_at => 1.week.from_now, :feedback_at => Time.now)]
      APN::Feedback.should_receive(:devices).and_return(devices)
      lambda {
        APN::Feedback.process_devices
      }.should change(APN::Device, :count).by(-1)
    end
    
  end
  
end