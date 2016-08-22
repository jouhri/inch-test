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

      data.each do | row |
        row.headers.each do | header |
          key = "#{model}:#{row["reference"]}:#{header}"
          unless $redis.zscore(key, row[header])
            index = $redis.zcard(key)
            $redis.zadd(key, index, row[header])
          end
        end
      end
    else
      puts "ERROR: \n Argements is missing ==> rake 'db:import_csv[model, file_path]'"
    end
  end
end
