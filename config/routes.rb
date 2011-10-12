Scprv4::Application.routes.draw do
  
  match '/about/people/staff/:name' => 'people#bio', :as => :bio
  match '/news/:year/:month/:day/:id/:slug' => 'news#story', :as => :news_story, :constraints => { :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/, :id => /\d+/, :slug => /[\w_-]+/}
  
  match '/' => "home#index", :as => :home
end
