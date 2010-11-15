class APN::PullNotification < APN::Base
  belongs_to :app, :class_name => 'APN::App'
  
  validates_presence_of :app_id

  def self.latest_since(app_id, since_date=nil)
    if since_date
      res = first(:order => "created_at DESC", 
                  :conditions => ["app_id = ? AND created_at > ? AND launch_notification = ?", app_id, since_date, false])
    else
      res = first(:order => "created_at DESC", 
                  :conditions => ["app_id = ? AND launch_notification = ?", app_id, true])
      res = first(:order => "created_at DESC", 
                  :conditions => ["app_id = ? AND launch_notification = ?", app_id, false]) unless res
    end
    res
  end
  
  def self.all_since(app_id, since_date=nil)
    if since_date
      res = all(:order => "created_at DESC", 
                :conditions => ["app_id = ? AND created_at > ? AND launch_notification = ?", app_id, since_date, false])
    else 
      res = all(:order => "created_at DESC", 
                :conditions => ["app_id = ? AND launch_notification = ?", app_id, false])
    end
  end
end