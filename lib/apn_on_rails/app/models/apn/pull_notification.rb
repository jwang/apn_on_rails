class APN::PullNotification < APN::Base
  belongs_to :app, :class_name => 'APN::App'
  
  validates_presence_of :app_id

  def self.latest_since(app_id, since_date=nil)
    conditions = if since_date
                   ["app_id = ? AND created_at > ?", app_id, since_date]
                 else
                   ["app_id = ?", app_id]
                 end

    first(:order => "created_at DESC", :conditions => conditions)
  end
end