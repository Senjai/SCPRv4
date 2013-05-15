require "csv"

# Format is:
# Jane Doe: YYYY-MM-DD - YYYY-MM-DD
str = <<-EOS
Erika Aguilar: 2012-12-01 - 2013-04-30
Leslie Berestein Rojas: 2012-12-01 - 2013-04-30
Ruxandra Guidi: 2012-12-01 - 2013-04-30
Rina Palta: 2012-12-01 - 2013-04-30
Alex Schaffert: 2012-12-01 - 2013-04-30
Evelyn Larrubia: 2012-12-01 - 2013-04-30
Mae Ryan: 2012-12-01 - 2013-04-30
Maya Sugarman: 2012-12-01 - 2013-04-30
Ashley Alvarado: 2012-12-01 - 2013-04-30
Leo Duran: 2012-12-01 - 2013-04-30
Stephen Hoffman: 2012-12-01 - 2013-04-30
Josie Huang: 2012-12-01 - 2013-04-30
Laura Krantz: 2012-12-01 - 2013-04-30
Michelle Lanz: 2012-12-01 - 2013-04-30
Jacob Margolis: 2012-12-01 - 2013-04-30
Steve Martin: 2012-12-01 - 2013-04-30
A Martinez: 2012-12-01 - 2013-04-30
Charles Castaldi: 2012-02-01 - 2013-04-30
Adolfo Guzman-Lopez: 2012-02-01 - 2013-04-30
Vanessa Romo: 2012-12-01 - 2013-03-31
Kim Bui: 2012-12-01 - 2013-03-31
Tami Abdollah: 2012-12-01 - 2012-12-15
Cheryl Devall: 2012-12-01 - 2013-02-19
Nick Roman: 2012-03-01 - 2013-04-30
Kristen Lepore: 2013-04-01 - 2013-04-30
EOS

# Classes to search for content
classes = ["NewsStory", "BlogEntry", "ShowSegment"]

# File name to dump the data into
# Set :username for interpolation
file_name = "stories-#{Time.now.to_i}-:username.csv"


#----------------------------
#----------------------------

user_ranges   = []

str.split("\n").each do |row|
  user_range = {}

  user_range[:user]  = Bio.find_by_name!(row.split(":")[0])
  user_range[:low]   = Time.parse(row.split(" ")[-3])
  user_range[:high]  = Time.parse(row.split(" ")[-1])

  user_ranges << user_range
end


rows = []

user_ranges.each do |range|
  bylines = range[:user].bylines.where(content_type: classes)
  
  bylines.select { |b| b.content.published? && b.content.published_at.between?(range[:low], range[:high]) }.each do |byline|
    content = byline.content
    rows << [content.published_at, content.to_title, "http://scpr.org#{content.link_path}", content.byline]
  end

  CSV.open(Rails.root.join("log", file_name.gsub(/\:username/, range[:user].name.parameterize)), "w+") do |csv|
    rows.each do |row|
      csv << row
    end
  end
end
