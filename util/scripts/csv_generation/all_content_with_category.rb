require "csv"
 
filename = "show-segments-2012"

content_types = [
  ShowSegment
]

low  = Time.new(2012, 1, 1, 0, 0, 0) - 1
high = Time.new(2013, 1, 1, 0, 0, 0) - 1

#------------------

rows = []

content_types.each do |type|
  type.published.where("published_at > :low and published_at <= :high", low: low, high: high).find_in_batches do |grp|
    grp.each do |content|
      wordcount = Nokogiri::HTML::DocumentFragment.parse(content.body.squish).text.split.count
      
      rows.push [
        content.obj_key, 
        content.show.title, 
        content.published_at,
        content.segment_asset_scheme.present? ? content.segment_asset_scheme : "default",
        content.category.try(:slug),
        content.short_headline,
        content.assets.first.try(:asset_id),
        content.audio.first.try(:duration),
        wordcount
      ]
    end
  end
end

CSV.open(Rails.root.join("log", "#{filename}-#{Time.now.strftime("%F")}.csv"), "w+",
  headers: true) do |csv|
  csv << [
    "UUID", 
    "Program", 
    "Publish Date", 
    "Asset Scheme", 
    "Category", 
    "Short Headline", 
    "Primary Asset ID", 
    "Primary Audio Duration (seconds)",
    "Wordcount (approximate)"
  ]
  
  rows.each do |row|
    csv << row
  end
end
