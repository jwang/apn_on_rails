require File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'spec_helper.rb')

describe APN::PullNotification do
  
  describe 'latest_since_when_already_seen_latest' do
    
    it 'should return nothing because since date is after the latest pull notification' do
      app = APN::App.first
      noty1 = PullNotificationFactory.create({:app_id => app.id})
      noty1.created_at = Time.now - 1.week
      noty1.save
      APN::PullNotification.latest_since(app.id,Time.now).should == nil      
    end
    
  end
  
  describe 'latest_since_when_have_not_seen_latest' do 
    
    it 'should return the most recent pull notification because it has not yet been seen' do 
      app = APN::App.first
      noty1 = PullNotificationFactory.create({:app_id => app.id})
      noty1.created_at = Time.now + 1.week
      noty1.save
      APN::PullNotification.latest_since(app.id,Time.now - 1.week).should == noty1 
    end

  end
  
  describe 'latest_since_with_no_date' do 
    it 'should return the most recent pull notification because no date is given' do 
      app = APN::App.first
      noty1 = APN::PullNotification.find(:first, :order => "created_at DESC")
      APN::PullNotification.latest_since(app.id).should == noty1
    end
  end
  
end