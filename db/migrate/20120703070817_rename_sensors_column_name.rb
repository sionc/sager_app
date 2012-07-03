class RenameSensorsColumnName < ActiveRecord::Migration
  def change
    rename_column :sensors, :name, :label
  end
end
