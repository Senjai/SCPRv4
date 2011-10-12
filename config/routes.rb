Scprv4::Application.routes.draw do
  
  match '/about/people/staff/:name' => 'people#bio', :as => :bio

  match '/blogs/:blog/:year/:month/:day/:id/:slug/' => "blogs#entry", :as => :blog_entry  
  match '/blogs/:blog/' => 'blogs#show', :as => :blog
  match '/blogs/' => 'blogs#index', :as => :blogs

  match '/programs/:show/:year/:month/:day/:id/:slug/' => "programs#segment", :as => :segment  
  match '/programs/:show/:year/:month/:day/' => "programs#episode", :as => :episode
  match '/programs/:show/' => 'programs#show', :as => :program
  match '/programs/' => 'programs#index', :as => :programs
  
  match '/news/:year/:month/:day/:id/:slug' => 'news#story', :as => :news_story, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}
  
  match '/' => "home#index", :as => :home
end
