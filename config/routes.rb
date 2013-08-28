Scprv4::Application.routes.draw do
  # Homepage
  root to: "home#index"
  match '/homepage/:id/missed-it-content/' => 'home#missed_it_content', as: :homepage_missed_it_content, default: { format: :js }


  # Listen Live
  get '/listen_live/' => 'listen#index', as: :listen


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
  # Legacy route for old Episode URLs
  get '/programs/:show/:year/:month/:day/'            => "programs#episode",                            constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }

  get '/programs/:show/archive/'                      => redirect("/programs/%{show}/#archive")
  post '/programs/:show/archive/'                     => "programs#archive",    as: :program_archive
  get '/programs/:show/:year/:month/:day/:id/'        => "programs#episode",    as: :episode,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/ }
  get '/programs/:show/:year/:month/:day/:id/:slug/'  => "programs#segment",    as: :segment,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w_-]+/}
  get '/programs/:show'                               => 'programs#show',       as: :program
  get '/programs/'                                    => 'programs#index',      as: :programs
  get '/schedule/'                                    => 'programs#schedule',   as: :schedule


  # Events
  get '/events/forum/archive/'            => 'events#archive',    as: :forum_events_archive
  get '/events/forum/'                    => 'events#forum',      as: :forum_events
  get '/events/sponsored/'                => 'events#index',      as: :sponsored_events,      defaults: { list: "sponsored" }
  get '/events/:year/:month/:day/:id/:slug/'  => 'events#show',   as: :event,                 constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w_-]+/ }
  get '/events/(list/:list)'              => 'events#index',      as: :events,                defaults: { list: "all" }

  # Legacy route
  get '/events/:year/:month/:day/:slug/'  => 'events#show', constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, slug: /[\w_-]+/}


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

  namespace :api, defaults: { format: "json" } do
    # PUBLIC
    scope module: "public" do
      # V2
      namespace :v2 do
        match '/' => "articles#options", constraints: { method: 'OPTIONS' }

        # Old paths
        get '/content'                  => 'articles#index'
        get '/content/by_url'           => 'articles#by_url'
        get '/content/most_viewed'      => 'articles#most_viewed'
        get '/content/most_commented'   => 'articles#most_commented'
        get '/content/*obj_key'         => 'articles#show'

        resources :articles, only: [:index] do
          collection do
            # These need to be in "collection", otherwise
            # Rails would expect an  :id parameter in
            # the URL.
            get 'most_viewed'      => 'articles#most_viewed'
            get 'most_commented'   => 'articles#most_commented'
            get 'by_url'           => 'articles#by_url'
            get '*obj_key'         => 'articles#show'
          end
        end

        resources :alerts, only: [:index, :show]
        resources :audio, only: [:index, :show]
        resources :editions, only: [:index, :show]
        resources :categories, only: [:index, :show]
        resources :events, only: [:index, :show]
        resources :programs, only: [:index, :show]
        resources :episodes, only: [:index, :show]
        resources :blogs, only: [:index, :show]

        resources :schedule, controller: 'schedule_occurrences',only: [:index] do
          collection do
            get :at,      to: "schedule_occurrences#show"
            get :current, to: "schedule_occurrences#show"
          end
        end
      end # V2


      # V3
      namespace :v3 do
        match '/' => "articles#options", constraints: { method: 'OPTIONS' }

        resources :articles, only: [:index] do
          collection do
            # These need to be in "collection", otherwise
            # Rails would expect an  :id parameter in
            # the URL.
            get 'most_viewed'      => 'articles#most_viewed'
            get 'most_commented'   => 'articles#most_commented'
            get 'by_url'           => 'articles#by_url'
            get '*obj_key'         => 'articles#show'
          end
        end

        resources :alerts, only: [:index, :show]
        resources :audio, only: [:index, :show]
        resources :editions, only: [:index, :show]
        resources :categories, only: [:index, :show]
        resources :events, only: [:index, :show]
        resources :programs, only: [:index, :show]
        resources :episodes, only: [:index, :show]
        resources :blogs, only: [:index, :show]

        resources :schedule, controller: 'schedule_occurrences',only: [:index] do
          collection do
            get :at,      to: "schedule_occurrences#show"
            get :current, to: "schedule_occurrences#show"
          end
        end
      end # V3
    end


    # PRIVATE
    namespace :private do
      # V2
      namespace :v2 do
        match '/' => "articles#options", constraints: { method: 'OPTIONS' }

        post '/utility/notify'   => 'utility#notify'

        resources :articles, only: [:index] do
          collection do
            # These need to be in "collection", otherwise
            # Rails would expect an  :id parameter in
            # the URL.
            get 'by_url'   => 'articles#by_url'
            get '*obj_key' => 'articles#show'
          end
        end
      end
    end
  end

  #------------------

  namespace :outpost do
    root to: 'home#index'

    resources :recurring_schedule_rules do
      get "search", on: :collection, as: :search
    end

    resources :schedule_occurrences do
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

    resources :external_programs do
      get "search", on: :collection, as: :search
    end

    resources :kpcc_programs do
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

    resources :abstracts do
      get 'search', on: :collection, as: :search
    end

    resources :editions

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

    resources :remote_articles, only: [:index] do
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
