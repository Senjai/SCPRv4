require "csv"
 
filename = "all-content-with-category"

content_types = [
  NewsStory,
  BlogEntry
]

low  = Time.new(2012, 2, 12, 0, 0, 0) - 1
high = Time.new(2013, 2, 12, 0, 0, 0) - 1

#------------------

rows = []

content_types.each do |type|
  type.published.where("published_at > :low and published_at <= :high", low: low, high: high).find_in_batches do |grp|
    grp.each do |content|
      rows.push [content.to_title, content.published_at, "http://scpr.org#{content.link_path}", content.category.try(:slug)]
    end
  end
end

CSV.open(Rails.root.join("log", "#{filename}-#{Time.now.strftime("%F")}.csv"), "w+",
  headers: true) do |csv|
  csv << ["Title", "Publish Date", "URL", "Category"]
  rows.each do |row|
    csv << row
  end
end
