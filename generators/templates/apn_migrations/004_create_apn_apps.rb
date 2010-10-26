class CreateApnApps < ActiveRecord::Migration # :nodoc:
  def self.up
    create_table :apn_apps do |t|
      t.text :apn_dev_cert
      t.text :apn_prod_cert

      t.timestamps
    end

    add_column :apn_devices, :app_id, :integer
    
  end

  def self.down
    drop_table :apn_apps
    remove_column :apn_devices, :app_id
  end
end
