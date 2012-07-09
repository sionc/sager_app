class AddDetailsToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :start_time, :integer
    add_column :schedules, :end_time, :integer
  end
end
