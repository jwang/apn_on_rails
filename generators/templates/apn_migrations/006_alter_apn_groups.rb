class AlterApnGroups < ActiveRecord::Migration # :nodoc:
  
  def self.up
    add_column :apn_groups, :app_id, :integer
  end

  def self.down
    remove_column :apn_groups, :app_id
  end
  
end