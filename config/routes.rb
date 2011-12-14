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
  
  match '/about/people/staff/:name' => 'people#bio', :as => :bio

  match '/blogs/:blog/:year/:month/:day/:id/:slug/' => "blogs#entry", :as => :blog_entry  
  match '/blogs/:blog/' => 'blogs#show', :as => :blog
  match '/blogs/' => 'blogs#index', :as => :blogs

  match '/programs/:show/:year/:month/:day/:id/:slug/' => "programs#segment", :as => :segment  
  match '/programs/:show/:year/:month/:day/' => "programs#episode", :as => :episode
  match '/programs/:show/' => 'programs#show', :as => :program
  match '/programs/' => 'programs#index', :as => :programs
  
  match '/videos/' => 'videos#index', :as => :videos
  
  match '/search/' => 'search#index', :as => :search
  
  match '/news/:year/:month/:day/:id/:slug' => 'news#story', :as => :news_story, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}

  match '/arts/:category(/:page)' => "category#index", :constraints => CategoryConstraint.new(false), :defaults => { :page => 1 }  
  match '/news/:category(/:page)' => "category#index", :constraints => CategoryConstraint.new(true), :defaults => { :page => 1 }
  
  match '/news/' => 'news#index', :as => :latest_news
  
  match '/' => "home#index", :as => :home
end
