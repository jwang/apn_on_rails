require 'rubygems'
require 'spec'

Dir.glob(File.join(File.dirname(__FILE__), 'extensions', '*.rb')).sort.each do |f|
  require f
end

require File.join(File.dirname(__FILE__), 'active_record', 'setup_ar.rb')

require File.join(File.dirname(__FILE__), '..', 'lib', 'apn_on_rails')

Dir.glob(File.join(File.dirname(__FILE__), 'factories', '*.rb')).sort.each do |f|
  require f
end

Spec::Runner.configure do |config|
  
  config.before(:all) do
    
  end
  
  config.after(:all) do
    
  end
  
  config.before(:each) do

  end
  
  config.after(:each) do
    
  end
  
end

def fixture_path(*name)
  return File.join(File.dirname(__FILE__), 'fixtures', *name)
end

def fixture_value(*name)
  return File.read(fixture_path(*name))
end

def write_fixture(name, value)
  File.open(fixture_path(*name), 'w') {|f| f.write(value)}
end