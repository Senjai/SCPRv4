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
    content << [0,cobj]
  rescue
    next
  end
end

# -- write them to cache -- #

top_traffic = view.render(:partial => "shared/widgets/most_popular_commented", :object => content, :as => :content)
Rails.cache.write("widget/popular_commented",top_traffic)
