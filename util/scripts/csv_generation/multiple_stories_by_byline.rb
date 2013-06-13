require "csv"

byline_regex = /^(?<name>.+?)\: (?<start>[\d-]+) - (?<end>[\d-]+)$/

withbio = <<-EOS
Erika Aguilar: 2013-05-01 - 2013-05-31
Leslie Berestein Rojas: 2013-05-01 - 2013-05-31
Ruxandra Guidi: 2013-05-01 - 2013-05-06
Adolfo Guzman-Lopez: 2013-05-01 - 2013-05-31
Rina Palta: 2013-05-01 - 2013-05-31
Nick Roman: 2013-05-01 - 2013-05-05
Jose Luis Jiménez: 2013-05-06 - 2013-05-31
Mae Ryan: 2013-05-01 - 2013-05-31
Maya Sugarman: 2013-05-01 - 2013-05-31
Ashley Alvarado: 2013-05-01 - 2013-05-31
A Martínez: 2013-05-01 - 2013-05-31
Laura Krantz: 2013-05-01 - 2013-05-31
Josie  Huang: 2013-05-01 - 2013-05-31
Leo Duran: 2013-05-01 - 2013-05-31
Jacob Margolis: 2013-05-01 - 2013-05-31
Michelle Lanz: 2013-05-01 - 2013-05-31
EOS

nobio = <<-EOS
Kristen Lepore: 2013-05-01 - 2013-05-31
Stephen Hoffman: 2013-05-01 - 2013-05-31
Steve Martin: 2013-05-01 - 2013-05-31
EOS


# Classes to search for content
classes = ["NewsStory", "BlogEntry", "ShowSegment"]

headers = [
    "Publish Date",
    "Title",
    "URL",
    "Byline"
  ]

# File name to dump the data into
# Set :username for interpolation
file_name = "stories-by-byline-#{Time.now.to_i}.csv"


#----------------------------
#----------------------------

# With Bio
user_ranges   = []
withbio.split("\n").each do |row|
  user_range = {}

  match = row.match(byline_regex)

  user_range[:user]  = Bio.find_by_name!(match[:name])
  user_range[:low]   = Time.parse(match[:start])
  user_range[:high]  = Time.parse(match[:end])

  user_ranges << user_range
end

# Without Bio
nobio_ranges = []
nobio.split("\n").each do |row|
  user_range = {}
  match = row.match(byline_regex)

  user_range[:name]  = match[:name]
  user_range[:low]   = Time.parse(match[:start])
  user_range[:high]  = Time.parse(match[:end])

  nobio_ranges << user_range
end



rows = []

user_ranges.each do |range|
  bylines = range[:user].bylines.where(content_type: classes)
  
  bylines.select { |b| b.content.published? && b.content.published_at.between?(range[:low], range[:high]) }.each do |byline|
    content = byline.content
    rows << [content.published_at, content.to_title, "http://scpr.org#{content.public_path}", content.byline]
  end
end


nobio_ranges.each do |range|
  bylines = ContentByline.where('name like ?', "%#{range[:name]}%").where(content_type: classes)

  bylines.select { |b| b.content.published? && b.content.published_at.between?(range[:low], range[:high]) }.each do |byline|
    content = byline.content
    rows << [content.published_at, content.to_title, "http://scpr.org#{content.public_path}", content.byline]
  end
end


CSV.open(Rails.root.join("log", file_name), "w+", headers: true) do |csv|
  csv << headers
  
  rows.each do |row|
    csv << row
  end
end
