class CreateSensorReadings < ActiveRecord::Migration
  def change
    create_table :sensor_readings do |t|
      t.integer :watthours,    :null => false, :default => 0
      t.integer :sensor_id,    :null => false

      t.datetime "created_at", :null => false
    end

    add_index :sensor_readings, :sensor_id
  end
end
