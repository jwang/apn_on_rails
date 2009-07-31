module APN
  class Base < ActiveRecord::Base # :nodoc:
    
    def self.table_name # :nodoc:
      self.to_s.gsub("::", "_").tableize
    end
    
  end
end