class RenameSensorReadingsColumn < ActiveRecord::Migration
  def change
    rename_column :sensor_readings, :sensor_id, :sensor_local_id
  end
end
