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

# Demo user
puts 'Creating demo user'
demo_user = User.create(:email => 'demo@polarmeter.com',
                        :password => 'password',
                        :demo => true)

puts "Creating demo sensors"
circle1 = Sensor.create(:label => "Circle 1",
                        :mac_address => "000D6F0000B81AB9",
                        :enabled => false,
                        :plus => true,
                        :user_id => demo_user.id)
circle2 = Sensor.create(:label => "Circle 2",
                        :mac_address => "000D6F0000B81A41",
                        :enabled => false,
                        :plus => false,
                        :user_id => demo_user.id)

other_user = User.create(:email => 'other@polarmeter.com',
                        :password => 'password',
                        :demo => true)

puts "Creating demo sensors"
circle3 = Sensor.create(:label => "Circle 3",
                        :mac_address => "000D6F0000B81AAA",
                        :enabled => false,
                        :plus => true,
                        :user_id => other_user.id)
puts "Seed complete!"
