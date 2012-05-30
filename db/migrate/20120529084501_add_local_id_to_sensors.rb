class AddLocalIdToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :local_id, :integer, :default => 0, :null => false
    add_index :sensors, [:hub_id, :local_id], :unique => true
  end
end
