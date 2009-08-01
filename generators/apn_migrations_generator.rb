require 'rails_generator'
# Generates the migrations necessary for APN on Rails.
# This should be run upon install and upgrade of the 
# APN on Rails gem.
# 
#   $ ruby script/generate apn_migrations
class ApnMigrationsGenerator < Rails::Generator::Base
  
  def manifest # :nodoc:
    record do |m|
      timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
      db_migrate_path = File.join('db', 'migrate')
      
      m.directory(db_migrate_path)
      
      Dir.glob(File.join(File.dirname(__FILE__), 'templates', 'apn_migrations', '*.rb')).sort.each_with_index do |f, i|
        f = File.basename(f)
        f.match(/\d+\_(.+)/)
        timestamp = timestamp.succ
        if Dir.glob(File.join(db_migrate_path, "*_#{$1}")).empty?
          m.file(File.join('apn_migrations', f), 
                 File.join(db_migrate_path, "#{timestamp}_#{$1}"), 
                 {:collision => :skip})
        end
      end
      
    end # record
    
  end # manifest
  
end # ApnMigrationsGenerator