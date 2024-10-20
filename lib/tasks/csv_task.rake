namespace :csv do
  desc 'Imports the csv dump into templates table'
  task :import do
    CSV.foreach('./tmp/metadata.csv', headers: true) do |row|
      hash = row.to_hash
      hash.delete("row")
      Template.create!(hash)
    end
  end

  desc 'Imports the csv dump into templates table'
  task :update do
    CSV.foreach('./tmp/templates_size.csv', headers: true) do |row|
      hash = row.to_hash
      Template.where(s3_key: hash['path']).update_all(size: hash['size_mb'])
    end
  end
end
