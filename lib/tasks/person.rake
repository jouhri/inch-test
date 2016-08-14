require 'csv'

namespace :person do
  desc "Generate csv file of Person attribute model with radom value"
  task :generate_csv, [:row, :file_path] =>  [:environment] do |t, args|
    if args[:row] && args[:file_path]
      CSV.open(args[:file_path], "wb") do |csv|
        csv << ["reference", "firstname", "lastname", "home_phone_number", "mobile_phone_number", "email", "address"]
        args[:row].to_i.times do | i |
          csv << [i.to_s, Faker::Name.first_name, Faker::Name.last_name, "0987654389", "8765908754", Faker::Internet.email, Faker::Address.street_address]
        end
      end
    else
      puts "ERROR: \n Argements is missing ==> rake 'person:generate_csv[nb_row, file_path]'"
    end
  end
end
