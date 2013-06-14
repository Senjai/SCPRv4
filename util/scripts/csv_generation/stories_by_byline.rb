require "csv"

# Bio Names to find
usernames = [
  "Lisa Brenner"
]

# Classes to search for content
classes = ["NewsStory", "BlogEntry"]

# File name to dump the data into
file_name = "stories-by-byline-#{Time.now.to_i}.csv"


#----------------------------
#----------------------------

users = []

usernames.each do |username|
  user = Bio.find_by_name!(username)
  users.push user
end

low  = Time.new(2012, 5, 1, 0, 0, 0) - 1
high = Time.new(2013, 3, 6, 0, 0, 0) - 1

rows = []

users.each do |user|
  bylines = user.bylines.where(content_type: classes)
  
  bylines.select { |b| b.content.published? && b.content.published_at.between?(low, high) }.each do |byline|
    content = byline.content
    rows.push [content.published_at, content.to_title, "http://scpr.org#{content.public_path}"]
  end
end

CSV.open(Rails.root.join("log", file_name), "w+") do |csv|
  rows.each do |row|
    csv << row
  end
end
