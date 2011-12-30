# run through rails runner

view = ActionView::Base.new(ActionController::Base.view_paths, {})  
   
class << view  
  include ApplicationHelper  
end

content = []

# -- get popular threads -- #

Disqussion::Client.threads.listPopular(:forum => "kpcc",:interval => "1d").response.each do |p|
  # find content object
  begin
    cobj = ContentBase.obj_by_key(p.identifiers[0])
    
    # now we work around disqus' stupid inability to give us the number of 
    # comments inside our interval by going in, grabbing all comments, and 
    # computing it on our own
    # FIXME: This will break if there are over 100 comments on the thread in this period
    
    t = Disqussion::Client.posts.list(
      :thread => p.id,
      :forum => "kpcc",
      :limit => 100, 
      :since => (Time.now - 86400).to_i,
      :order => "asc")
    
    count = 0
    
    if t.response
      count = t.response.size
    end
    
    content << [count,cobj]
  rescue
    next
  end
end

# -- write them to cache -- #

top_traffic = view.render(:partial => "shared/widgets/most_popular_commented", :object => content, :as => :content)
Rails.cache.write("widget/popular_commented",top_traffic)
