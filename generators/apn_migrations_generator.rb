require 'rails_generator'
# Generates the migrations necessary for APN on Rails
class ApnMigrationsGenerator < Rails::Generator::Base
  
  def manifest # :nodoc:
    record do |m|
      [:create_apn_devices, :create_apn_notifications].each do |f|
        m.migration_template(File.join('apn_migrations', "#{f}.rb"), "db/migrate", {:migration_file_name => f, :collision => :skip})
      end
    end
  end
  
end