require 'rails_generator'
# Generates the migrations necessary for APN on Rails
class ApnMigrationsGenerator < Rails::Generator::Base
  
  def manifest # :nodoc:
    record do |m|
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      db_migrate_path = File.join('db', 'migrate')
      
      m.directory(db_migrate_path)
      
      ['001_create_apn_devices', '002_create_apn_notifications'].each_with_index do |f, i|
        timestamp = timestamp.succ
        if Dir.glob(File.join(db_migrate_path, "*_#{f}.rb")).empty?
          m.file(File.join('apn_migrations', "#{f}.rb"), 
                 File.join(db_migrate_path, "#{timestamp}_#{f}.rb"), 
                 {:collision => :skip})
        end
      end
      
    end # record
    
  end # manifest
  
end # ApnMigrationsGenerator