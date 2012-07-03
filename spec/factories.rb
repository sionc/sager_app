FactoryGirl.define do
  #
  # Sequences
  #
  sequence :email do |n|
    "person#{n}@contoso.com"
  end

  # Slightly primitive, but will work for very small quantities of mac addresses
  # Get a mac address generator for better results
  sequence :mac_address do |n|
    "08:00:27:EA:03:A#{n}"
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

  # Sensor factory
  factory :sensor do
    mac_address

    # sugar for association with hub factory
    user
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
