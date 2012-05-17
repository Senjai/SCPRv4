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
    match '/enco'     => 'main#enco', :as => :enco
    
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
  match '/blogs/:blog/tagged/:tag/(page/:page)' => "blogs#blog_tagged", :as => :blog_entries_tagged,  trailing_slash: true
  match '/blogs/:blog/tagged/' => "blogs#blog_tags",                    :as => :blog_tags,            trailing_slash: true
  match '/blogs/:blog/:year/:month/:day/:id/:slug/' => "blogs#entry",   :as => :blog_entry,           trailing_slash: true, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}
  match '/blogs/:blog/(page/:page)' => 'blogs#show',                    :as => :blog,                 trailing_slash: true, :constraints => { :page => /\d+/ }
  match '/blogs/' => 'blogs#index',                                     :as => :blogs,                trailing_slash: true
  
  # -- Programs -- #
  match '/programs/:show/:year/:month/:day/:id/:slug/' => "programs#segment", :as => :segment  
  match '/programs/:show/:year/:month/:day/' => "programs#episode", :as => :episode
  match '/programs/:show(/page/:page)' => 'programs#show', :as => :program, :constraints => { :page => /\d+/ }
  match '/programs/' => 'programs#index', :as => :programs
  match '/schedule/' => 'programs#schedule', as: :schedule
  
  # -- Events -- #
  ## forum static pages
  match '/events/forum/space/request/'      => 'events#request',    as: :forum_request,         trailing_slash: true
  match '/events/forum/request/caterers/'   => 'events#caterers',   as: :forum_caterers,        trailing_slash: true
  match '/events/forum/space/'              => 'events#space',      as: :forum_space,           trailing_slash: true
  match '/events/forum/riots/'              => 'events#riots',      as: :forum_riots,           trailing_slash: true
  match '/events/forum/directions/'         => 'events#directions', as: :forum_directions,      trailing_slash: true
  match '/events/forum/volunteer/'          => 'events#volunteer',  as: :forum_volunteer,       trailing_slash: true
  match '/events/forum/about/'              => 'events#about',      as: :forum_about,           trailing_slash: true
  
  ## Event lists/details
  match '/events/forum/archive/'            => 'events#archive',    as: :forum_events_archive,  trailing_slash: true
  match '/events/forum/'                    => 'events#forum',      as: :forum_events,          trailing_slash: true
  match '/events/sponsored/'                => 'events#index',      as: :sponsored_events,      trailing_slash: true, defaults: { list: "sponsored" }
  match '/events/:year/:month/:day/:slug/'  => 'events#show',       as: :event,                 trailing_slash: true
  match '/events/(list/:list)'              => 'events#index',      as: :events,                trailing_slash: true, defaults: { list: "all" }

  
  # -- Videos -- #
  resources :video, only: [:index, :show], trailing_slash: true do
    match ':slug' => "video#show", on: :member
    match 'list', on: :collection, as: :list
  end
  
  # -- Listen Live -- #
  match '/listen_live/' => 'listen#index', :as => :listen
  
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
  match '/category/carousel-content/:object_class/:id' => 'category#carousel_content', as: :category_carousel, defaults: { format: :js }
  match '/news/' => 'category#news', :as => :latest_news
  match '/arts-life/' => 'category#arts', :as => :latest_arts
  
  # -- Home -- #
  match '/' => "home#index", :as => :home
  match '/beta/' => "home#beta", :as => :beta
  match '/listen' => "home#listen", as: :listen
  
  root to: "home#index"
  
  # catch error routes
  match '/404', :to => 'home#not_found'
  match '/500', :to => 'home#error'
end
