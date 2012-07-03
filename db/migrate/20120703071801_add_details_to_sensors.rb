class AddDetailsToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :enabled, :boolean
    add_column :sensors, :plus, :boolean
  end
end
