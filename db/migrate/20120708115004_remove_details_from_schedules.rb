class RemoveDetailsFromSchedules < ActiveRecord::Migration
  def up
    remove_column :schedules, :start_time
    remove_column :schedules, :end_time
  end

  def down
    add_column :schedules, :end_time, :time
    add_column :schedules, :start_time, :time
  end
end
