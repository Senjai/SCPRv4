# run through rails runner

view = ActionView::Base.new(ActionController::Base.view_paths, {})  
   
class << view  
  include ApplicationHelper  
end

# this is an interim process to work with the current mercer tracker

r = Redis.new(:host => "10.226.4.234", :port => 6379, :db => 1)
$stderr.puts "connected."

views = {}

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
  if !views[key]
    views[key] = 0
  end

  # get a count for tag date
  views[key] += r.hget(tag,'count').to_i

  #$stderr.puts "counting #{tag}\t#{views[tag]}"

end

$stderr.puts "in sort phase"

# sort views

content = []

views.sort_by { |k,v| v }.reverse()[0..9].each do |k,v|  
  obj = ContentBase.obj_by_key(k)
  
  if obj
    content << [v,obj]
  end
end

top_traffic = view.render(:partial => "shared/widgets/most_popular_viewed", :object => content, :as => :content)
Rails.cache.write("widget/popular_viewed",top_traffic)
