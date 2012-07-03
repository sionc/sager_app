class IndexSensorsOnMacAddress < ActiveRecord::Migration
  def change
    add_index :sensors, :mac_address, :unique => true
  end
end
