require 'csv'

namespace :building do
  desc "Generate csv file of Building attribute model with radom value"
  task :generate_csv, [:row, :file_path] =>  [:environment] do |t, args|
    if args[:row] && args[:file_path]
      CSV.open(args[:file_path], "wb") do |csv|
        csv << ["reference","address","zip_code","city","country","manager_name"]
        args[:row].to_i.times do | i |
          csv << [i.to_s, Faker::Address.street_address, Faker::Address.zip, Faker::Address.city, Faker::Address.country, Faker::Name.name]
        end
      end
    else
      puts "ERROR: \n Argements is missing ==> rake 'person:generate_csv[nb_row, file_path]'"
    end
  end
end
