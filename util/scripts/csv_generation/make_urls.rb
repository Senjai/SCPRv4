require 'csv'

rows = []

File.foreach("/Users/bryan/projects/Data Backups/hyper-2013-08-13.csv") do |line|
  puts line
  parts = CSV.parse(line.gsub('\"', '""'))[0]
  next if parts[0] == "published_at"

  date      = Time.parse(parts[0])
  headline  = parts[1]
  summary   = parts[2]
  byline    = parts[3]
  slug      = parts[4]

  url_date = date.strftime("%Y/%m/%d")
  url = "http://oncentral.org/news/#{url_date}/#{slug}/"

  rows.push [parts[0], parts[1], parts[2], parts[3], url]
end

CSV.open(Rails.root.join("log", "hyper-2013-08-13.csv"), "w+", headers: true) do |csv|
  csv << [
    "Publish Date", 
    "Headline", 
    "Summary", 
    "Byline", 
    "URL"
  ]
  
  rows.each do |row|
    csv << row
  end
end

