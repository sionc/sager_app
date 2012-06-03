FactoryGirl.define do
  #
  # Sequences
  #
  sequence :email do |n|
    "person#{n}@contoso.com"
  end

  sequence :sensor_name do |n|
    "sensor ##{n}"
  end

  # Slightly primitive, but will work for very small quantities of mac addresses
  # Get a mac address generator for better results
  sequence :mac_address do |n|
    "08:00:27:EA:03:A#{n}"
  end

  sequence :sensor_local_id do |n|
    n
  end

  #
  # Factories
  #

  # User factory
  factory :user do
    email
    password 'password'
    password_confirmation 'password'
  end

  # Hub factory
  factory :hub do
    mac_address

    # sugar for association with user factory
    user
  end

  # Sensor factory
  factory :sensor do
    name "MyString"
    local_id = FactoryGirl.generate :sensor_local_id

    # sugar for association with hub factory
    hub
  end

  # Sensor_reading factory
  factory :sensor_reading do
    watthours 1337

    # sugar for association with sensor factory
    sensor
  end

  # Role factory
  FactoryGirl.define do
    factory :role do
      name "MyString"
    end
  end
end
