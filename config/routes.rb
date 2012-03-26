class CategoryConstraint
  def initialize
    # load up category list
    @cats = Category.all.map { |c| c.slug }
  end
  
  def matches?(request)
    @cats.include?(request.params[:category])
  end
end

Scprv4::Application.routes.draw do
  match '/listen_live/demo' => 'dashboard/main#listen', :as => :listen_demo
  
  #namespace :api do
  #  match '/' => 'main#index', :as => :home
  #end
    
  namespace :dashboard do
    match '/sections' => 'main#sections', :as => :sections
    
    # ContentBase API
    match '/api/content/', :controller => 'api/content', :action => 'options', :constraints => {:method => 'OPTIONS'}
    namespace :api do
      resources :content, :id => /[\w\/\%]+(?:\:|%3A)\d+/ do
        collection do
          get :by_url
          get :recent
        end
        
        member do
          post :preview
        end
      end
    end
    
    match '/' => 'main#index', :as => :home
  end
  
  # -- Bios -- #
  match '/about/people/staff/:name' => 'people#bio', :as => :bio

  # -- Blogs -- #
  match '/blogs/:blog/tagged/:tag/(page/:page)' => "blogs#blog_tagged", :as => :blog_entries_tagged
  match '/blogs/:blog/tagged/' => "blogs#blog_tags", :as => :blog_tags
  match '/blogs/:blog/:year/:month/:day/:id/:slug/' => "blogs#entry", :as => :blog_entry, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}
  match '/blogs/:blog/(page/:page)' => 'blogs#show', :as => :blog, :constraints => { :page => /\d+/ }
  match '/blogs/' => 'blogs#index', :as => :blogs
  
  # -- Programs -- #
  match '/programs/:show/:year/:month/:day/:id/:slug/' => "programs#segment", :as => :segment  
  match '/programs/:show/:year/:month/:day/' => "programs#episode", :as => :episode
  match '/programs/:show(/page/:page)' => 'programs#show', :as => :program, :constraints => { :page => /\d+/ }
  match '/programs/' => 'programs#index', :as => :programs
  
  # -- Events -- #
  match '/events/:year/:month/:day/:slug/' => 'events#show', :as => :event
  match '/events/' => 'events#index', :as => :events
  
  # -- Videos -- #
  resources :video, only: [:index, :show] do
    match ':slug' => "video#show", on: :member
    match 'list', on: :collection, defaults: { format: :js }
  end
  
  # -- Search -- #
  match '/search/' => 'search#index', :as => :search
  
  # -- News Stories -- #
  match '/news/:year/:month/:day/:id/:slug/' => 'news#story', :as => :news_story, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}
  match '/news/:year/:month/:day/:slug/' => 'news#old_story', :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :slug => /[\w_-]+/ }

  # -- RSS feeds -- #
  match '/feeds/all_news' => 'feeds#all_news', :as => :all_news_feed
  
  # -- podcasts -- #
  match '/podcasts/:slug/' => 'podcasts#podcast', :as => :podcast
  match '/podcasts/' => 'podcasts#index', :as => :podcasts

  # -- Sections -- #
  match '/:category(/:page)' => "category#index", :constraints => CategoryConstraint.new, :defaults => { :page => 1 }, :as => :section
  match '/news/' => 'category#news', :as => :latest_news
  match '/arts-life/' => 'category#arts', :as => :latest_arts
  
  # -- Home -- #
  match '/' => "home#index", :as => :home
  match '/beta/' => "home#beta", :as => :beta
  
  root to: "home#index"
  
  # catch error routes
  match '/404', :to => 'home#not_found'
  match '/500', :to => 'home#error'
end
