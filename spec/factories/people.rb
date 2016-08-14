FactoryGirl.define do
  factory :person do
    sequence(:reference, 10000) {|n| n.to_s}
    email Faker::Internet.email
    home_phone_number "0137654899"
    mobile_phone_number "0678965422"
    firstname Faker::Name.first_name
    lastname Faker::Name.last_name
    address Faker::Address.street_address
  end
end
