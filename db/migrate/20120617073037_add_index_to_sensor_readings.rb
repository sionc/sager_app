class AddIndexToSensorReadings < ActiveRecord::Migration
  def change
    add_index :sensor_readings, [:sensor_id, :created_at]
  end
end
