# Note that this script only removes the ContentAsset objects
# It won't delete the actual Asset objects stored in AssetHost,
# nor will it put the fake assets back into the body of the post
# You'll need to un-import and re-import everything to do that.

blog_entries = BlogEntry.where('wp_id is not null').all
total_entries = blog_entries.size

blog_entries.each_with_index do |blog_entry, bindex|
  bindex += 1
  title = "BlogEntry ##{blog_entry.id}"
  boutof = "[#{bindex}/#{total_entries}]"
  
  if deleted = blog_entry.assets.delete_all
    msg ="Deleted #{MultiAmerican.view.pluralize(deleted.size, "assets")} for #{title} (#{deleted.map(&:id).join(", ")})"
  else
    msg = "Couldn't delete assets for #{title}"
  end
  
  puts "#{boutof} #{msg}"
end

# That's it!
