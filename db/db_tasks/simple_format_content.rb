# Turn all NewsStories/ShowSegments into HTMLified blocks of content.

klass = ARGV[0]

unless %w{NewsStory ShowSegment}.include? klass
  $stdout.puts "#{klass} not allowed."
  exit
end

include ActionView::Helpers::TextHelper

successes = []
errors    = []
log_file  = Rails.root.join("log/format-#{klass.underscore}.log")

start_time = Time.now
$stdout.puts "*** [#{start_time}] Formatting #{klass.titleize.pluralize}."

index = 0

klass.constantize.find_each do |story|
  begin
    if story.body !~ %r|^\<p|
      body = simple_format(story.body, {}, sanitize: false)
      story.update_column :body, body
    end

    if index % 1000 == 0
      $stdout.print "|"
    elsif index % 100 == 0
      $stdout.print "."
    end
    
    index += 1
    
    successes << story
  rescue Exception => e
    $stdout.print e#"X"
    errors << [story.id, e]
  end
  
  $stdout.flush
end
    
total_time = (Time.now - start_time)
$stdout.puts "\n*** [#{Time.now}] Finished in #{total_time} seconds. #{successes.size} Saved, #{errors.size} Errors."

if errors.size > 0
  File.open(log_file, "a") do |f|
    f.write errors.to_yaml
  end

  $stdout.puts "Errors logged to #{log_file}."
end
