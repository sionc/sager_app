class RemoveDetailsFromSensors < ActiveRecord::Migration
  def up
    remove_column :sensors, :hub_id
    remove_column :sensors, :local_id
  end

  def down
    add_column :sensors, :local_id, :integer
    add_column :sensors, :hub_id, :integer
  end
end
