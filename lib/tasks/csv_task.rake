namespace :csv do
  desc 'Imports the csv dump into templates table'
  task :import do
    CSV.foreach('./tmp/metadata.csv', headers: true) do |row|
      hash = row.to_hash
      hash.delete("row")
      Template.create!(hash)
    end
  end
end
