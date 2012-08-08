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
User.delete_all
Role.delete_all
Delayed::Job.delete_all

# Sion user
puts 'Creating demo user'
sion_user = User.create(:email => 'sion@polarmeter.com',
                        :password => 'password',
                        :demo => true)

puts "Creating demo sensors"

circle1 = Sensor.create(:label => "Entertainment Center",
                        :mac_address => "000D6F0000B81A42",
                        :enabled => true,
                        :plus => false,
                        :user_id => sion_user.id)
circle2 = Sensor.create(:label => "Living Room Lamp",
                        :mac_address => "000D6F0000B81A41",
                        :enabled => true,
                        :plus => false,
                        :user_id => sion_user.id)
circle3 = Sensor.create(:label => "Alex's Iron",
                        :mac_address => "000D6F0000B81AB9",
                        :enabled => true,
                        :plus => true,
                        :user_id => sion_user.id)
circle4 = Sensor.create(:label => "Coffee Maker",
                        :mac_address => "000D6F0000B81AB8",
                        :enabled => true,
                        :plus => false,
                        :user_id => sion_user.id)

# other_user = User.create(:email => 'other@polarmeter.com',
#                         :password => 'password',
#                         :demo => true)

# puts "Creating demo sensors"
# circle3 = Sensor.create(:label => "Other Circle",
#                         :mac_address => "000D6F0000B81AAA",
#                         :enabled => false,
#                         :plus => true,
#                         :user_id => other_user.id)
puts "Seed complete!"
