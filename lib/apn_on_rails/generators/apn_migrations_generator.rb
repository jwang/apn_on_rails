require 'rails_generator'
class ApnMigrationsGenerator < Rails::Generator::Base
  def manifest 
    record do |m|
      # m.template "rebba_tasks.rake", "lib/tasks/rebba_tasks.rake", :collision => :force
      #{fixtures}
      #{mts}
      
    end
  end
end