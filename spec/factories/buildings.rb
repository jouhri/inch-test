FactoryGirl.define do
  factory :building do
    sequence(:reference, 10000) {|n| n.to_s}
    address Faker::Address.street_address
    zip_code Faker::Address.zip
    city Faker::Address.city
    country Faker::Address.country
    manager_name Faker::Name.name
  end
end
