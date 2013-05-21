Scprv4::Application.routes.draw do
  # Homepage
  root to: "home#index"
  match '/homepage/:id/missed-it-content/' => 'home#missed_it_content', as: :homepage_missed_it_content, default: { format: :js }
  
  
  # Listen Live
  get '/listen_live/' => 'listen#index', as: :listen
  

  # May Elections
  match '/elections/2013/los-angeles-mayor-2013/' => 'specials#elections'

  # Sections
  match '/category/carousel-content/:object_class/:id' => 'category#carousel_content',  as: :category_carousel, defaults: { format: :js }
  get '/news/'                                       => 'category#news',              as: :latest_news
  get '/arts-life/'                                  => 'category#arts',              as: :latest_arts
  
  # RSS
  match '/feeds/all_news' => 'feeds#all_news', as: :all_news_feed
  match '/feeds/*feed_path', to: redirect { |params, request| "/#{params[:feed_path]}.xml" }
  
  
  # Podcasts
  match '/podcasts/:slug/' => 'podcasts#podcast', as: :podcast, defaults: { format: :xml }
  match '/podcasts/'       => 'podcasts#index',   as: :podcasts
  
  
  # Blogs / Entries
  get '/blogs/:blog/archive/:year/:month/'             => "blogs#archive",                as: :blog_archive,         constraints: { year: /\d{4}/, month: /\d{2}/ }
  post '/blogs/:blog/process_archive_select'           => "blogs#process_archive_select", as: :blog_process_archive_select
  get '/blogs/:blog/:year/:month/:day/:id/:slug/'      => "blogs#entry",                  as: :blog_entry,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w-]+/ }
  get '/blogs/:blog/tagged/:tag/'                      => "blogs#blog_tagged",            as: :blog_entries_tagged
  get '/blogs/:blog/'                                  => 'blogs#show',                   as: :blog
  get '/blogs/'                                        => 'blogs#index',                  as: :blogs
  
  
  # News Stories
  get '/news/:year/:month/:day/:id/:slug/'  => 'news#story',      as: :news_story,  constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w_-]+/}
  
  
  # Programs / Segments
  get '/programs/:show/archive/'                      => redirect("/programs/%{show}/#archive")
  post '/programs/:show/archive/'                     => "programs#archive",    as: :program_archive

  get '/programs/:show/:year/:month/:day/:id/:slug/'  => "programs#segment",    as: :segment,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w_-]+/}
  get '/programs/:show/:year/:month/:day/'            => "programs#episode",    as: :episode,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }
  get '/programs/:show'                               => 'programs#show',       as: :program
  get '/programs/'                                    => 'programs#index',      as: :programs
  get '/schedule/'                                    => 'programs#schedule',   as: :schedule
  
  
  # Events
  get '/events/forum/archive/'            => 'events#archive',    as: :forum_events_archive
  get '/events/forum/'                    => 'events#forum',      as: :forum_events
  get '/events/sponsored/'                => 'events#index',      as: :sponsored_events,      defaults: { list: "sponsored" }
  get '/events/:year/:month/:day/:slug/'  => 'events#show',       as: :event,                 constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, slug: /[\w_-]+/}
  get '/events/(list/:list)'              => 'events#index',      as: :events,                defaults: { list: "all" }
  
  
  # Search
  get '/search/' => 'search#index', as: :search
  
  
  # PIJ Queries
  get '/network/questions/:slug/' => "pij_queries#show",  as: :pij_query
  get '/network/'                 => "pij_queries#index", as: :pij_queries
  
  
  # About / Bios / Press
  get '/about/press/:slug'        => "press_releases#show",  as: :press_release
  get '/about/press/'             => "press_releases#index", as: :press_releases
  get '/about/people/staff/'      => 'people#index',         as: :staff_index
  get '/about/people/staff/:slug' => 'people#bio',           as: :bio
  get '/about'                    => "home#about_us",        as: :about
  
  
  # Videos
  get '/video/:id/:slug'  => "video#show",    as: :video, constraints: { id: /\d+/, slug: /[\w_-]+/ }
  get '/video/'           => "video#index",   as: :video_index
  get '/video/list/'      => "video#list",    as: :video_list
  
  
  # Article Email Sharing
  get   '/content/share' => 'content_email#new',    :as => :content_email
  post  '/content/share' => 'content_email#create', :as => :content_email


  # Archive
  post  '/archive/process/'             => "archive#process_form",  as: :archive_process_form
  get '/archive(/:year/:month/:day)/'   => "archive#show",          as: :archive,                 constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }
  
  
  # Extra (internal stuff)
  get '/breaking_email'   => 'breaking_news#show'
  
  
  # Sitemaps
  get '/sitemap' => "sitemaps#index", as: :sitemaps,  defaults: { format: :xml }
  get '/sitemap/:action',             as: :sitemap,   defaults: { format: :xml }, controller: "sitemaps"
  
  
  #------------------

  namespace :api do
    # PUBLIC
    scope module: "public" do
      # Temporary legacy routes
      match '/' => "v1/content#options", constraints: { method: 'OPTIONS' }
      
      get '/content'        => 'v1/content#index',  defaults: { format: :json }
      get '/content/by_url' => 'v1/content#by_url', defaults: { format: :json }
      get '/content/*obj_key'    => 'v1/content#show',   defaults: { format: :json }
      
      # V1
      namespace :v1 do
        match '/' => "content#options", constraints: { method: 'OPTIONS' }
    
        get '/content'        => 'content#index',  defaults: { format: :json }
        get '/content/by_url' => 'content#by_url', defaults: { format: :json }
        get '/content/*obj_key'    => 'content#show',   defaults: { format: :json }
      end

      # V2
      namespace :v2 do
        match '/' => "content#options", constraints: { method: 'OPTIONS' }
        
        get '/content'                  => 'content#index',  defaults: { format: :json }
        get '/content/by_url'           => 'content#by_url', defaults: { format: :json }
        get '/content/most_viewed'      => 'content#most_viewed', defaults: { format: :json }
        get '/content/most_commented'   => 'content#most_commented', defaults: { format: :json }
        get '/content/*obj_key'         => 'content#show',   defaults: { format: :json }

        get '/audio'     => 'audio#index', defaults: { format: :json }
        get '/audio/:id' => 'audio#show', defaults: { format: :json }
      end
    end
    
    
    # PRIVATE
    namespace :private do
      # V1
      namespace :v1 do
        match '/' => "content#options", constraints: { method: 'OPTIONS' }
        
        post '/utility/notify'   => 'utility#notify'

        get '/content'        => 'content#index',  defaults: { format: :json }
        get '/content/by_url' => 'content#by_url', defaults: { format: :json }
        get '/content/*obj_key'    => 'content#show',   defaults: { format: :json }
      end

      # V2
      namespace :v2 do
        match '/' => "content#options", constraints: { method: 'OPTIONS' }
        
        get '/content'        => 'content#index',  defaults: { format: :json }
        get '/content/by_url' => 'content#by_url', defaults: { format: :json }
        get '/content/*obj_key'    => 'content#show',   defaults: { format: :json }
      end
    end
  end

  #------------------
  
  namespace :outpost do
    root to: 'home#index'

    resources :recurring_schedule_slots do
      get "search", on: :collection, as: :search
    end

    resources :admin_users do
      get "search", on: :collection, as: :search
      get "activity", on: :member, as: :activity
    end
    
    resources :podcasts do
      get "search", on: :collection, as: :search
    end
          
    resources :breaking_news_alerts do
      get "search", on: :collection, as: :search
    end
    
    resources :featured_comment_buckets do
      get "search", on: :collection, as: :search
    end
    
    resources :categories do
      get "search", on: :collection, as: :search
    end
    
    resources :missed_it_buckets do
      get "search", on: :collection, as: :search
    end
    
    resources :promotions do
      get "search", on: :collection, as: :search
    end
    
    resources :sections do
      get "search", on: :collection, as: :search
    end
    
    resources :other_programs do
      get "search", on: :collection, as: :search
    end
    
    resources :kpcc_programs do
      get "search", on: :collection, as: :search
    end
    
    resources :video_shells do
      get "search", on: :collection, as: :search
    end
    
    resources :blogs do
      get "search", on: :collection, as: :search
    end
    
    resources :content_shells do
      get "search", on: :collection, as: :search
    end
    
    resources :featured_comments do
      get "search", on: :collection, as: :search
    end
    
    resources :data_points do
      get "search", on: :collection, as: :search
    end
    
    resources :show_episodes do
      get "search", on: :collection, as: :search
    end

    resources :bios do
      get "search", on: :collection, as: :search
    end
    
    resources :press_releases do
      get "search", on: :collection, as: :search
    end
    
    resources :homepages do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end
    
    resources :pij_queries do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end

    resources :flatpages do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end

    resources :show_segments do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end
    
    resources :news_stories do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end
    
    resources :blog_entries do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end
    
    resources :events do
      get "search", on: :collection, as: :search
      put "preview", on: :member
      post "preview", on: :collection
    end
    
    resources :tickets do
      get "search", on: :collection, as: :search
    end
    
    resources :npr_stories, only: [:index] do
      member do
        post "import", as: :import
        put "skip", as: :skip
      end
      
      collection do
        get "search", as: :search
        post "sync", as: :sync
      end
    end

    resources :sessions, only: [:create, :destroy]
    get 'login'  => "sessions#new", as: :login
    get 'logout' => "sessions#destroy", as: :logout
    
    get "/activity"                                        => "versions#activity",  as: :activity
    get "/:resources/:resource_id/history"                 => "versions#index",     as: :history
    get "/:resources/:resource_id/history/:version_number" => "versions#show",      as: :version

    get "trigger_error" => 'home#trigger_error'
    get "*path" => 'home#not_found'
  end

  get "trigger_error" => 'home#trigger_error'
  get "*path" => 'root_path#handle_path', as: :root_slug
end
