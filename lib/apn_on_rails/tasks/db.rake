namespace :apn do
  
  namespace :db do

    task :migrate do
      puts %{
This task no longer exists. Please generate the migrations like this:

$ ruby script/generate apn_migrations

Then just run the migrations like you would normally:

$ rake db:migrate
      }.strip
    end
    
  end # db
  
end # apn