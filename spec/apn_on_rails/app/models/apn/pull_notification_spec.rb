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
      latest = APN::PullNotification.latest_since(app.id,Time.now - 1.week)
      puts "latest is #{latest}"
      latest.should == noty1 
    end

  end
  
  describe 'latest_since_with_no_date_when_there_is_no_launch_notification' do 
    it 'should return the most recent pull notification because no date is given' do 
      app = APN::App.first
      noty1 = APN::PullNotification.find(:first, :order => "created_at DESC")
      APN::PullNotification.latest_since(app.id).should == noty1
    end
  end
  
  describe 'latest_since_with_no_date_when_there_is_a_launch_notification' do
    it 'should return the launch notification even though there is a more recent notification' do
      app = APN::App.first
      noty_launch = PullNotificationFactory.create({:app_id => app.id, :launch_notification => true})
      noty_launch.created_at = Time.now - 1.week
      noty_launch.save
      noty_nonlaunch = PullNotificationFactory.create({:app_id => app.id})
      APN::PullNotification.latest_since(app.id).should == noty_launch
    end
  end
  
  describe 'older_non_launch_noty_with_newer_launch_noty' do 
    it 'should return the older non launch notification even though a newer launch notification exists' do
      APN::PullNotification.all.each { |n| n.destroy }
      app = APN::App.first
      noty_launch = PullNotificationFactory.create({:app_id => app.id, :launch_notification => true})
      puts "noty_launch id is #{noty_launch.id}"
      noty_nonlaunch = PullNotificationFactory.create({:app_id => app.id})
      noty_nonlaunch.created_at = Time.now - 1.week
      noty_nonlaunch.save
      puts "noty_nonlaunch id is #{noty_nonlaunch.id}"
      APN::PullNotification.latest_since(app.id, Time.now - 2.weeks).should == noty_nonlaunch
    end
  end
  
  describe 'all_since_date_with_date_given' do 
    it 'should return all the non-launch notifications after the given date but not the ones before it' do 
      APN::PullNotification.all.each { |n| n.destroy }
      app = APN::App.first
      noty_launch = PullNotificationFactory.create({:app_id => app.id, :launch_notification => true})
      noty_launch.created_at = Time.now - 2.weeks
      noty_launch.save
      old_noty = PullNotificationFactory.create({:app_id => app.id})
      old_noty.created_at = Time.now - 2.weeks
      old_noty.save
      new_noty_one = PullNotificationFactory.create({:app_id => app.id})
      new_noty_one.created_at = Time.now - 1.day
      new_noty_one.save
      new_noty_two = PullNotificationFactory.create({:app_id => app.id})
      APN::PullNotification.all_since(app.id, Time.now - 1.week).should == [new_noty_two,new_noty_one]
    end
  end
  
  describe 'all_since_with_no_since_date_given' do 
    it 'should return all of the non-launch notifications' do 
      APN::PullNotification.all.each { |n| n.destroy }
      app = APN::App.first
      noty_launch = PullNotificationFactory.create({:app_id => app.id, :launch_notification => true})
      noty_launch.created_at = Time.now - 2.weeks
      noty_launch.save
      old_noty = PullNotificationFactory.create({:app_id => app.id})
      old_noty.created_at = Time.now - 2.weeks
      old_noty.save
      new_noty_one = PullNotificationFactory.create({:app_id => app.id})
      new_noty_one.created_at = Time.now - 1.day
      new_noty_one.save
      new_noty_two = PullNotificationFactory.create({:app_id => app.id})
      APN::PullNotification.all_since(app.id, Time.now - 3.weeks).should == [new_noty_two,new_noty_one,old_noty]
    end
  end
  
end