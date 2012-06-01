# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Deleting tables..."
SensorReading.delete_all
Sensor.delete_all
Hub.delete_all
User.delete_all

# See Data for Testing
user = User.create(:email => 'tim@contoso.com', :password => 'password')
hub = Hub.create(:user_id => user.id, :mac_address => '00:0C:29:60:65:18')
sensor = Sensor.create(:name => 'My Glorious Only Sensor', :hub_id => hub.id, :local_id => 1)

# Data for Demos
puts "Creating users"

unless User.find_by_email 'thomas.edison@sager.com'
  user_1 = User.create(
    :email                 => 'thomas.edison@sager.com',
    :password              => 'password',
    :password_confirmation => 'password'
  )
end

#unless User.find_by_email 'benjamin.franklin@sager.com'
#  user_2 = User.create(
#    :email                 => 'benjamin.franklin@sager.com',
#    :password              => 'password',
#    :password_confirmation => 'password'
#  )
#end
#
#unless User.find_by_email 'nikola.tesla@sager.com'
#  user_3 = User.create(
#    :email                 => 'nikola.tesla@sager.com',
#    :password              => 'password',
#    :password_confirmation => 'password'
#  )
#end

puts "Creating hubs..."
hub_1 =  Hub.create(:mac_address => "01:23:45:67:89:ab",
                    :user_id => user_1.id)


puts "Creating sensors..."
sensor_1 = Sensor.create(:name => "Television",
                         :hub_id => hub_1.id,
                         :local_id => 1)
sensor_2 = Sensor.create(:name => "Desktop",
                         :hub_id => hub_1.id,
                         :local_id => 2)
sensor_3 = Sensor.create(:name => "Space Heater",
                         :hub_id => hub_1.id,
                         :local_id => 3)

puts "Creating sensor_readings..."
sensors = [sensor_1, sensor_2, sensor_3]
sensors.each do |sensor|
  puts "Creating readings for sensor " + sensor.local_id.to_s
  (1..60*24*7).each do |i|
    min = 50
    max = 200
    reading = SensorReading.create(:watthours => rand(min..max),
                         :sensor_local_id => sensor.local_id)
    reading.created_at = Time.now.utc - i.minutes
    reading.save!
  end
end

puts "Seed complete!"