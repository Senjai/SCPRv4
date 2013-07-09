require "csv"
 
filename = "represent-export"

blogs = [
  "politics"
]

Rails.application.default_url_options[:host] = "http://scpr.org"

low  = Time.new(2013, 4, 14, 0, 0, 0) - 1
high = Time.new(2013, 6, 30, 0, 0, 0) - 1

#------------------

rows = []
 
blogs.each do |blog|
  blog = Blog.find_by_slug(blog)
  
  blog.entries.where("published_at > :low and published_at <= :high", low: low, high: high).published.reorder("published_at").each do |entry|
    rows.push [entry.published_at, entry.to_title, entry.byline, entry.public_url]
  end
end
 
CSV.open(Rails.root.join("log", "#{filename}-#{Time.now.strftime("%F")}.csv"), "w+") do |csv|
  rows.each do |row|
    csv << row
  end
end
