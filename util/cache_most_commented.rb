# run through rails runner

require 'rubypython'

# initialize pickle so that we can cache for mercer

# FIXME: Hardcoding production python path for now, but this should be fixed
if Rails.env == "production"
  RubyPython.start(:python_exe => "/usr/local/python2.7.2/bin/python")
else
  RubyPython.start()      
end
    
pickle = RubyPython.import("cPickle")

# initialize our rails view

view = ActionView::Base.new(ActionController::Base.view_paths, {})  
   
class << view  
  include ApplicationHelper  
end

content = []

# -- get popular threads -- #

Disqussion::Client.threads.listPopular(:forum => "kpcc",:interval => "3d").response.each do |p|
  # find content object
  begin
    cobj = ContentBase.obj_by_key(p.identifiers[0])
    count = p.posts_in_interval
    content << [count,cobj]
  rescue
    next
  end
end

# -- write them to cache -- #

top_traffic = view.render(:partial => "shared/widgets/most_popular_commented", :object => content, :as => :content)
Rails.cache.write("widget/popular_commented",top_traffic)


# write mercer cache

(Rails.cache.instance_variable_get :@data).set(
  ':1:most_popular:commented',
  pickle.dumps(top_traffic),
  :raw => true
)

