# run through rails runner

# initialize pickle so that we can cache for mercer

# FIXME: Hardcoding production python path for now, but this should be fixed
if Rails.env == "production"
  RubyPython.start(:python_exe => "/usr/local/python2.7.2/bin/python")
else
  RubyPython.start()      
end
    
pickle = RubyPython.import("cPickle")

# initialize our view for rendering

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

# write mercer cache

(Rails.cache.instance_variable_get :@data).set(
  ':1:most_popular:viewed',
  pickle.dumps(top_traffic),
  :raw => true
)
