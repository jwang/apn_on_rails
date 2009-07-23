namespace :apn do
  
  namespace :db do
    
    desc 'Runs the migrations for apn_on_rails.'
    task :migrate => [:environment] do
      puts File.join(File.dirname(__FILE__), '..', '..', 'apn_on_rails', 'db', 'migrate')
      ActiveRecord::Migrator.up(File.join(File.dirname(__FILE__), '..', '..', 'apn_on_rails', 'db', 'migrate'))
    end
    
  end # db
  
end # apn