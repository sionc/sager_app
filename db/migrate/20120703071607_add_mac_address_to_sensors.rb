class AddMacAddressToSensors < ActiveRecord::Migration
  def change
    add_column :sensors, :mac_address, :string
  end
end
