require "csv"

namespace :db do
  desc "updating database from external CSV files"
  task :import_csv, [:model, :file_path] => [:environment] do |t, args|
    if args[:model] && args[:file_path]
      begin
        model = Module.const_get(args[:model])
      rescue
        puts "ERROR: undefined model #{args[:model]}"
        exit 0
      end
      begin
        data = CSV.read(args[:file_path], headers:true)
      rescue
        puts "ERROR: No such file or directory for #{args[:file_path]}"
        exit 0
      end

      #headers = data[0].headers
      #sql_request_insert = "INSERT INTO #{model.to_s.downcase.pluralize} (#{headers.join(',')}, created_at, updated_at)  VALUES "

      references = model.pluck(:reference)

      data.each do | row |
        created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")

        if references.include?(row["reference"])
          model.where("reference = ? ", row["reference"]).first.update_attributes(row.to_hash)
        else
          res = model.create(row.to_hash)
          puts "ERROR on reference #{row["reference"]} ==> " + res.errors.full_messages.join(",") unless res.errors.full_messages.empty?
          # sql_values  = row.fields.map{ |v| ActiveRecord::Base.connection.quote(v)}
          # sql_request_insert += " (#{sql_values.join(', ')}, '#{created_at}', '#{created_at}'),"
          # ActiveRecord::Base.connection.execute(sql_request_insert.chomp(','))
        end
      end
    else
      puts "ERROR: \n Argements is missing ==> rake 'db:import_csv[model, file_path]'"
    end
  end
end
