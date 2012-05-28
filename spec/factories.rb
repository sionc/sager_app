FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@contoso.com"
  end

  factory :user do
    email
    password 'password'
    password_confirmation 'password'
  end

  # Hub factory
  factory :hub do
    mac_address '08:00:27:EA:03:7C'

    # sugar for association with user factory
    user
  end
end
