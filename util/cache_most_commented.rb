# run through rails runner

# initialize our rails view

view = ActionView::Base.new(ActionController::Base.view_paths, {})  
   
class << view  
  include ApplicationHelper  
end

content = []

# -- get popular threads -- #

Disqussion::Client.threads.listPopular(:forum => "kpcc",:interval => "3d").response.each do |p|
  # find content object
  cobj = ContentBase.obj_by_key(p.identifiers[0])
  count = p.posts_in_interval
    
  if cobj
    puts "content, count is #{cobj}, #{count}"
    content << [count,cobj]
  end
end

# -- write them to cache -- #

top_traffic = view.render(:partial => "shared/widgets/most_popular_commented", :object => content, :as => :content)
Rails.cache.write("widget/popular_commented",top_traffic)
