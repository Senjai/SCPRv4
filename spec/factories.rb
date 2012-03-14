FactoryGirl.define do  
  factory :asset, class: ContentAsset do
    sequence(:id, 1)
    asset_order 1
    asset_id 33585 # This is an actual BrightCove asset on AssetHost. This is not the best way to test this but it'll do for now.
    sequence(:caption) { |n| "Caption #{n}" } 
  end
  
  factory :byline, class: "ContentByline" do
    role 0
    user
  end
  
  factory :schedule do # Requires us to pass in kpcc_proram_id or other_program_id and program. There must be a better way to do this.
    sequence(:day) { |n| (Time.now + 60*60*24*n).day }
    start_time "00:00:00" # arbitrary
    end_time "02:00:00" # aribtrary
    url { "/programs/#{program.underscore}" }
  end
  
  factory :user, class: "Bio", aliases: [:author] do
    bio "This is a bio"
    short_bio "Short!"
    email "email@kpcc.org"
    is_public true
    last_name "Ricker"
    name "Bryan Ricker"
    slugged_name "bryan-ricker"
    title "Rails Developer"
    twitter "@kpcc"
    sequence(:user_id) 
  end
  
  factory :link do
    title "A Related Link"
    link "http://oncentral.org"
    link_type "website"
  end
    
  factory :kpcc_program, aliases: [:show] do
    sequence(:title) { |n| "Show #{n}" }
    sequence(:slug) { |n| "show-#{n}" }
    teaser "AirTalk, short teaser, etc."
    description "This is the description for AirTalk!"
    host "Larry Mantle"
    airtime "Weekdays 10 a.m.-12 p.m."
    air_status "onair"
    podcast_url "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast?id=73329334&uo=6"
    rss_url "http://feeds.scpr.org/kpccAirTalk"
    sidebar "Sidebar Content"    
    twitter_url "airtalk"
    facebook_url "http://www.facebook.com/KPCC.AirTalk"
    display_segments 1
    display_episodes 1
    
    ignore { episode_count 0 }
    ignore { segment_count 0 }
    after_create do |kpcc_program, eval|
      FactoryGirl.create_list(:show_episode, eval.episode_count, show: kpcc_program)
      FactoryGirl.create_list(:show_segment, eval.segment_count, show: kpcc_program)
    end
  end
  
  factory :other_program do
    sequence(:title) { |n| "Other Program #{n}" }
    sequence(:slug) { |n| "other-program-#{n}" }
    teaser "Outside Program"
    description "This is the description for the outside program!"
    host "Larry Mantle"
    airtime "Weekdays 10 a.m.-12 p.m."
    air_status "onair"
    podcast_url "http://www.npr.org/rss/podcast.php?id=510294"
    rss_url "http://oncentral.org/rss/latest" # This column cannot be null?
    sidebar "Sidebar Content"
    web_url "http://www.bbc.co.uk/worldservice/"
    produced_by "BBC"
  end
  
  factory :show_rundown do
    episode
    segment
    sequence(:segment_order) { |n| n }
  end
  
  factory :blog do
    sequence(:name) { |n| "Blog #{n}" }
    sequence(:slug) { |n| "blog-#{n}" }
    sequence(:_teaser) { |n| "This is the blog #{n} teaser" }
    description "This is a description for this blog."
    head_image "http://media.scpr.org/assets/images/heads/larry_transparent.png"
    is_active true
    is_remote false
    is_news true
    feed_url "http://feeds.scpr.org/LarryMantleBlog"
    custom_url "http://scpr.org" # it's a required field?
    
    factory :news_blog do
      is_news true
    end
    
    factory :non_news_blog do
      is_news false
    end
    
    factory :remote_blog do
      is_remote true
      feed_url "http://oncentral.org/rss/latest"
    end
  end
  
  factory :category do
    trait :is_news do 
      sequence(:category) { |n| "Local #{n}" }
      sequence(:slug) { |n| "local-#{n}" }
      is_news true
      sequence(:comment_bucket_id)
    end
    
    trait :is_not_news do
      sequence(:category) { |n| "Culture #{n}" }
      sequence(:slug) { |n| "culture-#{n}" }
      is_news false
      sequence(:comment_bucket_id)
    end
    
    factory :category_news, traits: [:is_news]
    factory :category_not_news, traits: [:is_not_news]
  end
  
  factory :related do
    factory :brel do # "brels" - expects content to be passed in
      association :related, factory: :show_segment
    end
    
    factory :frel do # "frels" - expects related to be passed in
      association :content, factory: :show_segment
    end
  end
  
 # factory :content_category do
 #   category
 # end
  
  ### ContentBase Classes
  ##### NOTE: The name of the factory should eq ClassName.to_s.underscore.to_sym, i.e. NewsStory = :news_story
  ##### This is to please #make_content in /spec/support/content_methods.rb
  
  factory :video_shell do
    association :category, factory: :category_not_news
    sequence(:headline) { |n| "This is a video #{n}" }
    status 5
    sequence(:slug) { |n| "slug-#{n}" }
    sequence(:published_at) { |n| Time.now + 60*n }
    body "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet non congue libero commodo. Vestibulum dolor nibh, eleifend eu suscipit eget, egestas sed diam. Proin cursus rutrum nibh eget consequat. Donec viverra augue sed nisl ultrices venenatis id eget quam. Cras id dui a magna tristique fermentum in sit amet lacus. Curabitur urna metus, mattis vel mollis quis, placerat vitae turpis.
    Phasellus et tortor eget mauris imperdiet fermentum. Mauris a rutrum augue. Quisque at fringilla libero. Phasellus vitae nisl turpis, at sodales erat. Duis et risus orci, at placerat quam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam sed nibh non odio pretium rhoncus et nec ipsum. Nam sed dignissim velit."
    
    ignore { asset_count 1 }
    ignore { link_count 0 }
    ignore { brels_count 0 }
    ignore { frels_count 0 }
    after_create do |video_shell, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: video_shell)
      FactoryGirl.create_list(:link, eval.link_count, content: video_shell)
      FactoryGirl.create_list(:brel, eval.brels_count, content: video_shell)
      FactoryGirl.create_list(:frel, eval.frels_count, related: video_shell)
    end
  end
  
  factory :news_story do
    association :category, factory: :category_news
    primary_reporter_id 7
    headline "This is a news story"
    sequence(:slug) { |n| "news-story-#{n}" }
    news_agency "KPCC"
    _teaser "This is a teaser"
    body "This is a big block of text for the news story"
    locale "local"
    sequence(:published_at) { |n| Time.now + 60*n }
    editing_status 2
    is_published 1 # required field by db but not used anymore
    status 5
    byline "Local Byline"
    comment_count 1
    
    ignore { asset_count 0 }
    ignore { link_count 0 }
    ignore { brels_count 0 }
    ignore { frels_count 0 }
    after_create do |news_story, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: news_story)
      FactoryGirl.create_list(:link, eval.link_count, content: news_story)
      FactoryGirl.create_list(:brel, eval.brels_count, content: news_story)
      FactoryGirl.create_list(:frel, eval.frels_count, related: news_story)
    end
  end
  
  factory :show_episode, aliases: [:episode] do
    show
    sequence(:air_date) { |n| (Time.now + 60*60*24*n).strftime("%Y-%m-%d") }
    title "AirTalk for May 22, 2009"
    _teaser "This is a short summary of the show"
    sequence(:published_at) { |n| Time.now + 60*n }
    status 5
    comment_count 0
    
    ignore { asset_count 0 }
    ignore { link_count 0 }
    ignore { brels_count 0 }
    ignore { frels_count 0 }
    after_create do |show_episode, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: show_episode)
      FactoryGirl.create_list(:link, eval.link_count, content: show_episode)
      FactoryGirl.create_list(:brel, eval.brels_count, content: show_episode)
      FactoryGirl.create_list(:frel, eval.frels_count, related: show_episode)
    end
  end
  
  factory :show_segment, aliases: [:segment] do
    show
    association :category, factory: :category_not_news
    sequence(:title) { |n| "Show Segment #{n}" }
    sequence(:slug) { |n| "show-segment-#{n}" }
    _teaser "This is a teaser for the show segment"
    body "This is a description of the show segment"
    locale "local"
    status 5
    comment_count 1
    _short_headline "Short Headline"
    sequence(:published_at) { |n| Time.now + 60*n }
    audio_date Time.now
    enco_number 999
    
    ignore { asset_count 0 }
    ignore { link_count 0 }
    ignore { brels_count 0 }
    ignore { frels_count 0 }
    after_create do |show_segment, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: show_segment)
      FactoryGirl.create_list(:link, eval.link_count, content: show_segment)
      FactoryGirl.create_list(:brel, eval.brels_count, content: show_segment)
      FactoryGirl.create_list(:frel, eval.frels_count, related: show_segment)
    end
  end
  
  factory :blog_entry do
    association :category, factory: :category_not_news
    sequence(:title) { |n| "Blog Entry #{n}" }
    sequence(:slug) { |n| "blog-entry-#{n}" }
    content "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet non congue libero commodo. Vestibulum dolor nibh, eleifend eu suscipit eget, egestas sed diam. Proin cursus rutrum nibh eget consequat. Donec viverra augue sed nisl ultrices venenatis id eget quam. Cras id dui a magna tristique fermentum in sit amet lacus. Curabitur urna metus, mattis vel mollis quis, placerat vitae turpis.
    Phasellus et tortor eget mauris imperdiet fermentum. Mauris a rutrum augue. Quisque at fringilla libero. Phasellus vitae nisl turpis, at sodales erat. Duis et risus orci, at placerat quam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam sed nibh non odio pretium rhoncus et nec ipsum. Nam sed dignissim velit."
    author
    blog
    blog_slug { slug }
    status 5
    is_published 1 # required field by db but not used anymore
    comment_count 1
    sequence(:published_at) { |n| Time.now + 60*n }
    
    ignore { asset_count 0 }
    ignore { link_count 0 }
    ignore { brels_count 0 }
    ignore { frels_count 0 }
    after_create do |blog_entry, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: blog_entry)
      FactoryGirl.create_list(:link, eval.link_count, content: blog_entry)
      FactoryGirl.create_list(:brel, eval.brels_count, content: blog_entry)
      FactoryGirl.create_list(:frel, eval.frels_count, related: blog_entry)
    end
  end
  
  factory :content_shell do
    association :category, factory: :category_news
    comment_count 2
    headline "This is some outside Content"
    byline "Some Reporter"
    site "blogdowntown"
    _teaser "This is a teaser for the content"
    url "http://blogdowntown.com/2011/11/6494-green-paint-welcomes-cyclists-to-a-reprioritized"
    status 5
    sequence(:pub_at) { |n| Time.now + 60*n }
    
    ignore { asset_count 0 }
    ignore { link_count 0 }
    ignore { brels_count 0 }
    ignore { frels_count 0 }
    after_create do |content_shell, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: content_shell)
      FactoryGirl.create_list(:link, eval.link_count, content: content_shell)
      FactoryGirl.create_list(:brel, eval.brels_count, content: content_shell)
      FactoryGirl.create_list(:frel, eval.frels_count, related: content_shell)
    end
  end
end