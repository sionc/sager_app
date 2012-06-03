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
Role.delete_all

# See Data for Testing
user = User.create(:email => 'tim@contoso.com', :password => 'password')
hub = Hub.create(:user_id => user.id, :mac_address => '00:0C:29:60:65:18')
sensor = Sensor.create(:name => 'My Ancient Fridge',
                       :hub_id => hub.id,
                       :local_id => 1)

# User for authorization testing
user2 = User.create(:email => 'sion@contoso.com', :password => 'password')
hub2 = Hub.create(:user_id => user2.id, :mac_address => '00:0C:29:60:65:19')
sensor2 = Sensor.create(:name => 'Dishwasher',
                       :hub_id => hub2.id,
                       :local_id => 1)
SensorReading.create(:watthours => 80085,
                     :sensor_id => sensor2.id)

# Other user for authorization testing
user3 = User.create(:email => 'alex@contoso.com', :password => 'password')
hub3 = Hub.create(:user_id => user3.id, :mac_address => '00:0C:29:60:65:20')
sensor3 = Sensor.create(:name => 'Microwave',
                       :hub_id => hub3.id,
                       :local_id => 1)
SensorReading.create(:watthours => 7175,
                     :sensor_id => sensor3.id)
# Data for Demos
puts "Creating users"

unless User.find_by_email 'thomas.edison@sager.com'
  user_1 = User.create(:email                 => 'thomas.edison@sager.com',
                       :password              => 'password',
                       :password_confirmation => 'password'
  )
end

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
  puts "Creating readings for sensor " + sensor.id.to_s
  (1..60*24*7).each do |i|
    min = 50
    max = 200
    reading = SensorReading.create(:watthours => rand(min..max),
                         :sensor_id => sensor.id)
    reading.created_at = Time.now.utc - i.minutes
    reading.save!
  end
end

puts "Seed complete!"
