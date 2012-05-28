class CreateSensors < ActiveRecord::Migration
  def up
    create_table :sensors do |t|
      t.string :name
      t.integer :hub_id

      t.timestamps
    end

    add_index(:sensors, :hub_id)
  end

  def down
    drop_table :sensors
  end
end
