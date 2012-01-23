class CategoryConstraint
  def initialize(news = false)
    # load up category list
    @cats = Category.where(:is_news => news).all.map { |c| c.slug }
  end
  
  def matches?(request)
    @cats.include?(request.params[:category])
  end
end

Scprv4::Application.routes.draw do
    
  namespace :dashboard do
    match '/sections' => 'main#sections', :as => :sections
    match '/' => 'main#index', :as => :home
  end
  
  match '/about/people/staff/:name' => 'people#bio', :as => :bio

  match '/blogs/:blog/:year/:month/:day/:id/:slug/' => "blogs#entry", :as => :blog_entry  
  match '/blogs/:blog/(page/:page)' => 'blogs#show', :as => :blog
  match '/blogs/' => 'blogs#index', :as => :blogs

  match '/programs/:show/:year/:month/:day/:id/:slug/' => "programs#segment", :as => :segment  
  match '/programs/:show/:year/:month/:day/' => "programs#episode", :as => :episode
  match '/programs/:show/' => 'programs#show', :as => :program
  match '/programs/' => 'programs#index', :as => :programs
  
  match '/events/:year/:month/:day/:slug/' => 'events#show', :as => :event
  match '/events/' => 'events#index', :as => :events
  
  match '/videos/' => 'videos#index', :as => :videos
  
  match '/search/' => 'search#index', :as => :search
  
  match '/news/:year/:month/:day/:id/:slug/' => 'news#story', :as => :news_story, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}
  match '/news/:year/:month/:day/:slug/' => 'news#old_story', :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :slug => /[\w_-]+/ }

  match '/arts/:category(/:page)' => "category#arts", :constraints => CategoryConstraint.new(false), :defaults => { :page => 1 }, :as => :arts_section
  match '/news/:category(/:page)' => "category#news", :constraints => CategoryConstraint.new(true), :defaults => { :page => 1 }, :as => :news_section
  
  match '/news/' => 'news#index', :as => :latest_news
  match '/arts/' => 'news#arts', :as => :latest_arts
  
  match '/' => "home#index", :as => :home
  match '/beta/' => "home#beta", :as => :beta
end
