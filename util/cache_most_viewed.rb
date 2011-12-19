# run through rails runner

view = ActionView::Base.new(ActionController::Base.view_paths, {})  
   
class << view  
  include ApplicationHelper  
end

# this is an interim process to work with the current mercer tracker

#r = Redis.new(:host => "localhost", :port => 6380, :db => 1)
$stderr.puts "connected."

views = {}

if false
  r.smembers('tag_dates').each do |tag|
    # split for obj_key::date
    (key,date) = tag.split("::")
    #$stderr.puts "tag is #{tag}"
  
    # parse date to see if we care
    date = Date.parse(date)
  
    # ignore tags more than two days old
    if Date.today - date > 2
      next
    end
    
    # init record
    if !views[tag]
      views[tag] = 0
    end

    # get a count for tag date
    views[tag] += r.hget(tag,'count').to_i
  
    #$stderr.puts "counting #{tag}\t#{views[tag]}"
  
  end
end

views["news/story:30389"] = 7325
views["news/story:9070"] = 1526
views["shows/segment:21785"] = 705
views["blogs/entry:4021"] = 600
views["news/story:30396"] = 513

$stderr.puts "in sort phase"

# sort views

content = []

views.sort_by { |k,v| v }.reverse()[0..9].each do |k,v|
  puts "#{k}\t#{v}"
  
  obj = ContentBase.obj_by_key(k)
  
  if obj
    content << [v,obj]
  end
end

top_traffic = view.render(:partial => "shared/widgets/most_popular_viewed", :content => content)
Rails.cache.write("widget/popular_viewed",top_traffic)
