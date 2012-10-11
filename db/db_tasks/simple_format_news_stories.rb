# Turn all NewsStories into HTMLified blocks of content.

include ActionView::Helpers::TextHelper

successes = []
errors    = []
log_file  = Rails.root.join("log/format-news-stories.log")

start_time = Time.now
$stdout.puts "*** [#{start_time}] Formatting News Stories."

NewsStory.all.each_with_index do |story, index|
  begin
    story.body = simple_format(story.body, {}, sanitize: false)
    story.save!

    if index % 10000 == 0
      $stdout.print "|"
    elsif index % 100 == 0
      $stdout.print "."
    end
    
    successes << story
  rescue Exception => e
    $stdout.print "X"
    errors << [story.id, e]
  end
end
    
total_time = ((Time.now - start_time) / 60).floor
$stdout.puts "\n*** [#{Time.now}] Finished in #{total_time} minutes. #{successes.size} Saved, #{errors.size} Errors."

if errors.size > 0
  File.open(log_file, "a") do |f|
    f.write errors.to_yaml
  end

  $stdout.puts "Errors logged to #{log_file}."
end
