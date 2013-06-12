require "csv"
 
shows = [
  "brand-martinez",
  "take-two"
]
 
low  = Time.new(2012, 9, 10, 0, 0, 0) - 1
high = Time.new(2012, 12, 1, 0, 0, 0) - 1
 
rows = []
 
shows.each do |show|
  program = KpccProgram.find_by_slug(show)
  
  program.segments.where("published_at > :low and published_at <= :high", low: low, high: high).published.reorder("published_at").each do |segment|
    rows.push [segment.published_at, segment.to_title, "http://scpr.org#{segment.public_path}", segment.byline]
  end
end
 
CSV.open("/Users/bricker/Desktop/taketwo-segments.csv", "w+") do |csv|
  rows.each do |row|
    csv << row
  end
end

