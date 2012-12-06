class FlatpageConstraint
  def initialize
    @flatpages = Flatpage.all.map { |f| f.path } rescue []
  end
  
  def matches?(request)
    @flatpages.include?(request.params[:flatpage_path])
  end
end

#---------

class SectionConstraint
  def initialize
    @sections = Section.all.map { |s| s.slug } rescue []
  end
  
  def matches?(request)
    @sections.include?(request.params[:slug])
  end
end

#---------

class CategoryConstraint
  def initialize
    @categories = Category.all.map { |c| c.slug } rescue []
  end
  
  def matches?(request)
    @categories.include?(request.params[:category])
  end
end

#---------

Scprv4::Application.routes.draw do
  # Homepage
  root to: "home#index"
  match '/homepage/:id/missed-it-content/' => 'home#missed_it_content', as: :homepage_missed_it_content, default: { format: :js }
  
  
  # Listen Live
  match '/listen_live/' => 'listen#index', as: :listen
  
  
  # Sections
  match '/category/carousel-content/:object_class/:id' => 'category#carousel_content',  as: :category_carousel, defaults: { format: :js }
  match '/news/'                                       => 'category#news',              as: :latest_news
  match '/arts-life/'                                  => 'category#arts',              as: :latest_arts
  
  
  # Flatpage paths will override anything below this route.
  match '*flatpage_path' => "flatpages#show", constraints: FlatpageConstraint.new
  match '/:slug(/:page)'     => "sections#show",  constraints: SectionConstraint.new,   defaults: { page: 1 }, as: :section
  match '/:category(/:page)' => "category#index", constraints: CategoryConstraint.new,  defaults: { page: 1 }, as: :category
  
  
  # RSS
  match '/feeds/all_news' => 'feeds#all_news', as: :all_news_feed
  match '/feeds/*feed_path', to: redirect { |params, request| "/#{params[:feed_path]}.xml" }
  
  
  # Podcasts
  match '/podcasts/:slug/' => 'podcasts#podcast', as: :podcast
  match '/podcasts/'       => 'podcasts#index',   as: :podcasts
    
  
  # Blogs / Entries
  match '/blogs/:blog/tagged/:tag/(page/:page)'          => "blogs#blog_tagged",            as: :blog_entries_tagged
  match '/blogs/:blog/tagged/'                           => "blogs#blog_tags",              as: :blog_tags
  match '/blogs/:blog/archive/:year/:month/(page/:page)' => "blogs#archive",                as: :blog_archive,         constraints: { year: /\d{4}/, month: /\d{2}/ }
  post  '/blogs/:blog/process_archive_select'            => "blogs#process_archive_select", as: :blog_process_archive_select
  match '/blogs/:blog/category/:category/(page/:page)'   => "blogs#category",               as: :blog_category
  match '/blogs/:blog/:year/:month/:day/:id/:slug/'      => "blogs#entry",                  as: :blog_entry,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w-]+/ }
  match '/blogs/:blog/:year/:month/:slug'                => 'blogs#legacy_path',            as: :legacy_path,          constraints: { year: /\d{4}/, month: /\d{2}/, slug: /[\w-]+/ }
  match '/blogs/:blog/(page/:page)'                      => 'blogs#show',                   as: :blog,                 constraints: { page: /\d+/ }
  match '/blogs/'                                        => 'blogs#index',                  as: :blogs
  
  
  # News Stories
  match '/news/:year/:month/:day/:id/:slug/'  => 'news#story',      as: :news_story,  constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w_-]+/}
  match '/news/:year/:month/:day/:slug/'      => 'news#old_story',                    constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, slug: /[\w_-]+/ }
  
  
  # Programs / Segments
  match '/programs/:show/archive/'                      => "programs#archive",    as: :program_archive
  match '/programs/:show/:year/:month/:day/:id/:slug/'  => "programs#segment",    as: :segment  
  match '/programs/:show/:year/:month/:day/'            => "programs#episode",    as: :episode
  match '/programs/:show(/page/:page)'                  => 'programs#show',       as: :program,           constraints: { page: /\d+/ }
  match '/programs/'                                    => 'programs#index',      as: :programs
  match '/schedule/'                                    => 'programs#schedule',   as: :schedule
  
  
  # Events
  match '/events/forum/archive/'            => 'events#archive',    as: :forum_events_archive
  match '/events/forum/'                    => 'events#forum',      as: :forum_events
  match '/events/sponsored/'                => 'events#index',      as: :sponsored_events,      defaults: { list: "sponsored" }
  match '/events/:year/:month/:day/:slug/'  => 'events#show',       as: :event
  match '/events/(list/:list)'              => 'events#index',      as: :events,                defaults: { list: "all" }
  
  
  # Search
  match '/search/' => 'search#index', as: :search
  
  
  # PIJ Queries
  match '/network/questions/:slug/' => "pij_queries#show",  as: :pij_query
  match '/network/'                 => "pij_queries#index", as: :pij_queries
  
  
  # About / Bios / Press
  match '/about/press/:slug'        => "press_releases#show",  as: :press_release
  match '/about/press/'             => "press_releases#index", as: :press_releases
  match '/about/people/staff/'      => 'people#index',         as: :staff_index
  match '/about/people/staff/:slug' => 'people#bio',           as: :bio
  match '/about'                    => "home#about_us",        as: :about
  
  
  # Elections - Turn this into a flatpage and remove it!
  match '/elections/2012/results/' => 'home#elections'
  
  
  # Videos
  match '/video/:id/:slug'  => "video#show",    as: :video, constraints: { id: /\d+/, slug: /[\w_-]+/ }
  match '/video/'           => "video#index",   as: :video_index
  match '/video/list/'      => "video#list",    as: :video_list
  
  
  # Article Email Sharing
  get   '/content/share' => 'content_email#new',    :as => :content_email
  post  '/content/share' => 'content_email#create', :as => :content_email


  # Archive
  post  '/archive/process/'               => "archive#process_form",  as: :archive_process_form
  match '/archive(/:year/:month/:day)/'   => "archive#show",          as: :archive,                 constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }
  

  # catch error routes
  match '/404', to: 'home#not_found'
  match '/500', to: 'home#error'
  
  
  # Extra (internal stuff)
  match '/listen_live/demo' => 'dashboard/main#listen', :as => :listen_demo
  match '/breaking_email'   => 'breaking_news#show'
  
  
  # Sitemaps
  match '/sitemap' => "sitemaps#index", as: :sitemaps,  defaults: { format: :xml }
  match '/sitemap/:action',             as: :sitemap,   defaults: { format: :xml }, controller: "sitemaps"
  
  
  #------------------

  namespace :api do
    match '/api/content/' => "api/content#options", constraints: { method: 'OPTIONS' }
    
    get '/content'        => 'api#index',  defaults: { format: :json }
    get '/content/key'    => 'api#show',   defaults: { format: :json }
    get '/content/by_url' => 'api#by_url', defaults: { format: :json }
  end
  
  #------------------
  
  namespace :dashboard do
    match '/sections' => 'main#sections', :as => :sections
    match '/enco'     => 'main#enco', :as => :enco
    match '/notify'   => 'main#notify'
    
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
  
  #------------------
  
  scope "r" do
    namespace :admin do
      root to: 'home#index'
      
      get 'login'  => "sessions#new", as: :login
      get 'logout' => "sessions#destroy", as: :logout
      resources :sessions, only: [:create, :destroy]
      
      get '/search(/:resource)' => "search#index", as: :search
      
      ## -- AdminResource -- ##
      resources :press_releases
      resources :recurring_schedule_slots
      resources :permissions
      resources :bios
      resources :audio
      resources :admin_users
      resources :podcasts
      resources :schedules
      resources :breaking_news_alerts
      resources :featured_comment_buckets
      resources :categories
      resources :missed_it_buckets
      resources :promotions
      resources :sections
      resources :pij_queries
      resources :tags
      resources :other_programs
      resources :show_segments
      resources :show_episodes
      resources :kpcc_programs
      resources :news_stories
      resources :blogs
      resources :blog_entries
      resources :flatpages
      resources :video_shells
      resources :events
      resources :homepages
      resources :content_shells
      resources :featured_comments
      resources :data_points
      ## -- END AdminResource --  ##
            
      get "/activity"                                        => "versions#activity",  as: :activity
      get "/:resources/:resource_id/history"                 => "versions#index",     as: :history
      get "/:resources/:resource_id/history/:version_number" => "versions#show",      as: :version
    end
  end
end
