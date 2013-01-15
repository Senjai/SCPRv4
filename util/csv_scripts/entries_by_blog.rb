require "csv"
 
filename = "represent-export"

blogs = [
  "politics"
]

low  = Time.new(2012, 8, 23, 0, 0, 0) - 1
high = Time.new(2012, 12, 1, 0, 0, 0) - 1

#------------------

rows = []
 
blogs.each do |blog|
  blog = Blog.find_by_slug(blog)
  
  blog.entries.where("published_at > :low and published_at <= :high", low: low, high: high).published.reorder("published_at").each do |entry|
    rows.push [entry.published_at, entry.to_title, "http://scpr.org#{entry.link_path}", entry.byline]
  end
end
 
CSV.open(File.join(File.absolute_path(File.dirname(__FILE__)), "results", "#{filename}-#{Time.now.strftime("%F")}.csv"), "w+") do |csv|
  rows.each do |row|
    csv << row
  end
end
