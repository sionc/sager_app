FactoryGirl.define do
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

    # sugar for association with hub factory
    hub
  end
end
