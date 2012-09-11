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

class QuickSlugConstraint
  def initialize
    @quick_slugs = KpccProgram.where("quick_slug != ''").all.map { |f| f.quick_slug }.compact rescue []
  end
  
  def matches?(request)
    @quick_slugs.include?(request.params[:quick_slug])
  end
end

#---------

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
  
  scope "r" do
    namespace :admin do
      get 'login'  => "sessions#new", as: :login
      get 'logout' => "sessions#destroy", as: :logout
      resources :sessions, only: [:create, :destroy]
      
      get '/search(/:resource)' => "search#index",      as: :search

      ## -- AdminResource -- ##
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
      ## -- END AdminResource --  ##
      
      get "/activity"                                         => "versions#activity", as: :activity
      get "/:resources/:resource_id/history"                  => "versions#index",    as: :versions
      get "/:resources/:resource_id/versions/:version_number" => "versions#show",     as: :version
      get "/:resources/:resource_id/versions/:a_num..:b_num"  => "versions#compare",  as: :version_compare
      
      scope "multi_american" do
        get "/"         => "multi_american#index",    as: :multi_american
        post "/set_doc" => "multi_american#set_doc",  as: :multi_american_set_doc
        
        get     ":resource_name"             => "multi_american#resource_index",       as: "index_multi_american_resource"
        post    ":resource_name/import"      => "multi_american#import",               as: "multi_american_multiple_import"
        delete  ":resource_name/remove"      => "multi_american#remove",               as: "multi_american_multiple_remove"

        get     ":resource_name/:id"         => "multi_american#resource_show",        as: "show_multi_american_resource"
        post    ":resource_name/:id/import"  => "multi_american#import",               as: "multi_american_import"
        delete  ":resource_name/:id/remove"  => "multi_american#remove",               as: "multi_american_remove"
      end

      root to: 'home#index'
    end
  end
  
  
  # Flatpage paths will override anything below this route.
  match '*flatpage_path'     => "flatpages#show", constraints: FlatpageConstraint.new
  
  
  # -- Bios -- #
  match '/about/people/staff/'      => 'people#index',  as: :staff_index
  match '/about/people/staff/:name' => 'people#bio',    as: :bio



  # -- Blogs -- #
  match '/blogs/:blog/tagged/:tag/(page/:page)'          => "blogs#blog_tagged",            as: :blog_entries_tagged
  match '/blogs/:blog/tagged/'                           => "blogs#blog_tags",              as: :blog_tags
  match '/blogs/:blog/archive/:year/:month/(page/:page)' => "blogs#archive",                as: :blog_archive,         constraints: { year: /\d{4}/, month: /\d{2}/ }
  post  '/blogs/:blog/process_archive_select'            => "blogs#process_archive_select", as: :blog_process_archive_select
  match '/blogs/:blog/category/:category/(page/:page)'   => "blogs#category",               as: :blog_category
  match '/blogs/:blog/:year/:month/:day/:id/:slug/'      => "blogs#entry",                  as: :blog_entry,           constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w-]+/ }
  match '/blogs/:blog/:year/:month/:slug'                => 'blogs#legacy_path',            as: :legacy_path,          constraints: { year: /\d{4}/, month: /\d{2}/, slug: /[\w-]+/ }
  match '/blogs/:blog/(page/:page)'                      => 'blogs#show',                   as: :blog,                 constraints: { page: /\d+/ }
  match '/blogs/'                                        => 'blogs#index',                  as: :blogs
  
  
  
  # -- Programs -- #
  match '/programs/:show/archive/'                      => "programs#archive",    as: :program_archive
  match '/programs/:show/:year/:month/:day/:id/:slug/'  => "programs#segment",    as: :segment  
  match '/programs/:show/:year/:month/:day/'            => "programs#episode",    as: :episode
  match '/programs/:show(/page/:page)'                  => 'programs#show',       as: :program,           constraints: { page: /\d+/ }
  match '/programs/'                                    => 'programs#index',      as: :programs
  match '/schedule/'                                    => 'programs#schedule',   as: :schedule
  
  
  
  # -- Events -- #
  match '/events/forum/about/'              => 'events#about',      as: :forum_about,           trailing_slash: true
  
  ## Event lists/details
  match '/events/forum/archive/'            => 'events#archive',    as: :forum_events_archive
  match '/events/forum/'                    => 'events#forum',      as: :forum_events
  match '/events/sponsored/'                => 'events#index',      as: :sponsored_events,      defaults: { list: "sponsored" }
  match '/events/:year/:month/:day/:slug/'  => 'events#show',       as: :event
  match '/events/(list/:list)'              => 'events#index',      as: :events,                defaults: { list: "all" }

  match '/events/forum/space/request/'      => 'events#request',    as: :forum_request
  match '/events/forum/request/caterers/'   => 'events#caterers',   as: :forum_caterers
  match '/events/forum/space/'              => 'events#space',      as: :forum_space
  match '/events/forum/riots/'              => 'events#riots',      as: :forum_riots
  match '/events/forum/directions/'         => 'events#directions', as: :forum_directions
  match '/events/forum/volunteer/'          => 'events#volunteer',  as: :forum_volunteer
  match '/events/forum/about/'              => 'events#about',      as: :forum_about
  
  
  
  # -- Videos -- #
  match '/video/:id/:slug'  => "video#show",    as: :video, constraints: { id: /\d+/, slug: /[\w_-]+/ }
  match '/video/'           => "video#index",   as: :video_index
  match '/video/list/'      => "video#list",    as: :video_list
  
  
  
  # -- Listen Live -- #
  match '/listen_live/' => 'listen#index', as: :listen
  
  # -- Breaking News --#
  match '/breaking_email' => 'breaking_news#show'
  
  # -- Search -- #
  match '/search/' => 'search#index', as: :search
  
  # -- Article Email Sharing -- #
  get   '/content/share' => 'content_email#new',    :as => :content_email
  post  '/content/share' => 'content_email#create', :as => :content_email

  # -- Archive -- #
  post  '/archive/process/'               => "archive#process_form",  as: :archive_process_form
  match '/archive(/:year/:month/:day)/'   => "archive#show",          as: :archive,                 constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/ }
  
  # -- News Stories -- #
  match '/news/:year/:month/:day/:id/:slug/'  => 'news#story',      as: :news_story,  constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, id: /\d+/, slug: /[\w_-]+/}
  match '/news/:year/:month/:day/:slug/'      => 'news#old_story',                    constraints: { year: /\d{4}/, month: /\d{2}/, day: /\d{2}/, slug: /[\w_-]+/ }
  
  #----------
  # PIJ Queries
  match '/network/questions/:slug/' => "pij_queries#show",  as: :pij_query
  match '/network/'                 => "pij_queries#index", as: :pij_queries
  
  # -- RSS feeds -- #
  match '/feeds/all_news' => 'feeds#all_news', as: :all_news_feed
  match '/feeds/*feed_path', to: redirect { |params, request| "/#{params[:feed_path]}.xml" }
  
  # -- podcasts -- #
  match '/podcasts/:slug/' => 'podcasts#podcast', as: :podcast
  match '/podcasts/'       => 'podcasts#index',   as: :podcasts

  # -- Sections -- #
  match '/category/carousel-content/:object_class/:id' => 'category#carousel_content',  as: :category_carousel, defaults: { format: :js }
  match '/news/'                                       => 'category#news',              as: :latest_news
  match '/arts-life/'                                  => 'category#arts',              as: :latest_arts
  
  # -- Home -- #
  match '/'                                => "home#index",             as: :home
  match '/about'                           => "home#about_us",          as: :about
  match '/homepage/:id/missed-it-content/' => 'home#missed_it_content', as: :homepage_missed_it_content, default: { format: :js }
  
  # catch error routes
  match '/404', to: 'home#not_found'
  match '/500', to: 'home#error'
  
  # Extra
  match '/fb_channel_file' => 'home#fb_channel_file'
  
  # Sitemaps
  match '/sitemap' => "sitemaps#index", as: :sitemaps,  defaults: { format: :xml }
  match '/sitemap/:action',             as: :sitemap,   defaults: { format: :xml }, controller: "sitemaps"
  
  # -- Dynamic root-level routes -- #
  match '/:slug(/:page)'     => "sections#show",  constraints: SectionConstraint.new,   defaults: { page: 1 }, as: :section
  match '/:category(/:page)' => "category#index", constraints: CategoryConstraint.new,  defaults: { page: 1 }, as: :category
  match '/:quick_slug'       => "programs#show",  constraints: QuickSlugConstraint.new
  
  root to: "home#index"
end
