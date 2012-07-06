class IndexSchedules < ActiveRecord::Migration
  def change
    add_index :schedules, :sensor_id
    add_index :schedules, [:sensor_id, :created_at]
  end
end
