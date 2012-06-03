class RenameSensorReadingsLocalSensorId < ActiveRecord::Migration
  def up
    rename_column :sensor_readings, :sensor_local_id, :sensor_id
  end

  def down
    rename_column :sensor_readings, :sensor_id, :sensor_local_id
  end
end
