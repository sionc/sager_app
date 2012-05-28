class CreateHubs < ActiveRecord::Migration
  def up
    create_table :hubs do |t|
      t.string :mac_address
      t.integer :user_id

      t.timestamps
    end

    add_index :hubs, :mac_address, :unique => true
  end

  def down
    drop_table :hubs
  end
end
