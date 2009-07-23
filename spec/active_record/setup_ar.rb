require 'rubygems'
require 'activerecord'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO
ActiveRecord::Base.logger = logger

db_file = File.join(File.dirname(__FILE__), 'test.db')
# FileUtils.rm(db_file) if File.exists?(db_file)
File.open(db_file, 'w')

ActiveRecord::Base.establish_connection({
  :adapter => 'sqlite3',
  :dbfile => db_file
})

ActiveRecord::Migrator.up(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'apn_on_rails', 'db', 'migrate'))