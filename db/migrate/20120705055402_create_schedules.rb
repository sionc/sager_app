class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.time :start_time
      t.time :end_time
      t.integer :sensor_id

      t.timestamps
    end
  end
end
