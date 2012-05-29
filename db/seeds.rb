# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Hub.delete_all
Sensor.delete_all
SensorReading.delete_all

user = User.create(:email => 'tim@contoso.com', :password => 'password')
hub = Hub.create(:user_id => user.id, :mac_address => '00:0C:29:60:65:18')
sensor = Sensor.create(:name => 'My Glorious Only Sensor', :hub_id => hub.id, :local_id => 1)
