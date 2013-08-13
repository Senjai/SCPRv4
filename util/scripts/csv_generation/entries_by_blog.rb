# Rails.root.join("log", "#{filename}-#{Time.now.strftime("%F")}.csv")

require "csv"
 
filename = "represent-export"

blogs = [
  "southla"
]

Rails.application.default_url_options[:host] = "http://scpr.org"

low  = Time.new(2012, 8, 1, 0, 0, 0) - 1
high = Time.new(2013, 7, 31, 0, 0, 0) - 1

#------------------

rows = []
 
blogs.each do |blog|
  blog = Blog.find_by_slug(blog)
  
  blog.entries.where("published_at > :low and published_at <= :high", low: low, high: high).published.reorder("published_at").each do |entry|
    rows.push [entry.published_at, entry.to_title, entry.teaser, entry.byline]
  end
end

CSV.open("/Users/bryan/projects/Data Backups/hyper-2013-08-13.csv", "a+") do |csv|
  rows.each do |row|
    csv << row
  end
end
