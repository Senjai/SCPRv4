FactoryGirl.define do  
  factory :asset, class: ContentAsset do
    sequence(:id, 1)
    asset_order 1
    asset_id 33585 # This is an actual BrightCove asset on AssetHost. This is not the best way to test this but it'll do for now.
    sequence(:caption) { |n| "Caption #{n}" } 
  end
  
  factory :byline, class: "ContentByline" do # TODO: Make a "content" factory so we don't have to fake the content fields
    role 0
    user
    content_type_id 15
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

  factory :show, class: "KpccProgram" do
    sequence(:title) { |n| "Show #{n}" }
    sequence(:slug) { |n| "show-#{n}" }
    teaser "AirTalk, short teaser, etc."
    description "This is the description for AirTalk!"
    host "Larry Mantle"
    airtime "Weekdays 10 a.m.-12 p.m."
    air_status "onair"
    podcast_url "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast?id=73329334&uo=6"
    rss_url "http://feeds.scpr.org/kpccAirTalk"
    twitter_url "airtalk"
    facebook_url "http://www.facebook.com/KPCC.AirTalk"
    is_segmented 1 
  end
  
  factory :blog do
    sequence(:name) { |n| "Blog #{n}" }
    sequence(:slug) { |n| "blog-#{n}" }
    description "This is a description for this blog."
    head_image "http://media.scpr.org/assets/images/heads/larry_transparent.png"
    is_active 1
    feed_url "http://feeds.scpr.org/LarryMantleBlog"
    is_remote 0
    is_news 1
    custom_url "http://multiamerican.scpr.org/" # hax, and it's a required field for some reason.
  end
  
  factory :category do
    trait :is_news do 
      sequence(:category) { |n| "Local #{n}" }
      sequence(:slug) { |n| "local-#{n}" }
      is_news '1'
      sequence(:comment_bucket_id)
    end
    
    trait :is_not_news do
      sequence(:category) { |n| "Culture #{n}" }
      sequence(:slug) { |n| "culture-#{n}" }
      is_news 0
      sequence(:comment_bucket_id)
    end
    
    factory :category_news, traits: [:is_news]
    factory :category_not_news, traits: [:is_not_news]
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
    sequence(:published_at) { |n| Time.now + 60*n }
    body "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque a enim a leo auctor lobortis. Etiam aliquam metus sit amet nulla blandit molestie. Cras lobortis odio non turpis laoreet non congue libero commodo. Vestibulum dolor nibh, eleifend eu suscipit eget, egestas sed diam. Proin cursus rutrum nibh eget consequat. Donec viverra augue sed nisl ultrices venenatis id eget quam. Cras id dui a magna tristique fermentum in sit amet lacus. Curabitur urna metus, mattis vel mollis quis, placerat vitae turpis.
    Phasellus et tortor eget mauris imperdiet fermentum. Mauris a rutrum augue. Quisque at fringilla libero. Phasellus vitae nisl turpis, at sodales erat. Duis et risus orci, at placerat quam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Etiam sed nibh non odio pretium rhoncus et nec ipsum. Nam sed dignissim velit."
    
    ignore { asset_count 1 }
    after_create do |video_shell, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: video_shell)
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
    is_published 1
    status 5
    byline "Local Byline"
    comment_count 1
    
    ignore { asset_count 1 }
    after_create do |news_story, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: news_story)
    end
  end
  
  factory :show_segment do
    association :category, factory: :category_not_news
    show
    sequence(:title) { |n| "Show Segment #{n}" }
    sequence(:slug) { |n| "show-segment-#{n}" }
    byline "KPCC"
    outside_reporter 1
    _teaser "This is a teaser for the show segment"
    body "This is a description of the show segment"
    locale "local"
    is_published 1
    status 5
    comment_count 1
    _short_headline "Short Headline"
    sequence(:published_at) { |n| Time.now + 60*n }
    
    ignore { asset_count 1 }
    after_create do |show_segment, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: show_segment)
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
    blog_slug "larry-mantle" # FIXME This should match the entry's blog's slug
    status 5
    is_published 1 # Do we need this? It's currently a required field in the DB
    comment_count 1
    sequence(:published_at) { |n| Time.now + 60*n }
    
    ignore { asset_count 1 }
    after_create do |blog_entry, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: blog_entry)
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
    sequence(:pub_at) { |n| Time.now + 60*n } # TODO Replace `pub_at` with `published_at` for consistency 
    
    ignore { asset_count 1 }
    after_create do |content_shell, eval|
      FactoryGirl.create_list(:asset, eval.asset_count, content: content_shell)
    end
  end
end