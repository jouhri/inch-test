require "csv"

namespace :db do
  desc "updating database from external CSV files"
  task :import_csv, [:model, :file_path] => [:environment] do |t, args|
    if args[:model] && args[:file_path]
      begin
        Module.const_get(args[:model])
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

      model = args[:model].downcase.pluralize

      data.each do | row |
         created_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
         sql_values  = row.fields.map{ |v| ActiveRecord::Base.connection.quote(v)}
         sql = "
                INSERT INTO #{model} (#{row.headers.join(',')}, created_at, updated_at)
                VALUES (#{sql_values.join(', ')}, '#{created_at}',  '#{created_at}')
         "
         puts sql
         res = ActiveRecord::Base.connection.execute(sql)
         ActiveRecord::Base.connection.last_inserted_id(res)
      end
    else
      puts "ERROR: \nArgements is missing ==> rake 'db:import_csv[model, file_path]'"
    end
  end
end
