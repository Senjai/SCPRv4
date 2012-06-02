@segments = ShowSegment.all
@dups = []

@segments.each do |segment| 
  dup = ShowSegment.where("slug = ? and DATE(published_at) = ? and id != ?", segment.slug, segment.published_at.strftime("%Y-%m-%d"), segment.id).first
  @dups << dup if dup.present?
end

@dup_groups = @dups.group_by(&:slug)

@dup_groups.each do |dup_group|
  slug = dup_group[0]
  dups = dup_group[1].sort_by(&:id)
  puts "#{slug}: #{dups.map(&:id).join(", ")}"
end