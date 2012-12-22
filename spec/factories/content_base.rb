FactoryGirl.define do
  
##########################################################
### ContentBase Classes
##### *NOTE:* The name of the factory should eq `ClassName.to_s.underscore.to_sym`, i.e. NewsStory = :news_story
##### This is to please `#make_content` / `#sphinx_spec` in /spec/support/thinking_sphinx_helpers.rb
##########################################################

# ContentBase - Common attributes ##########################################################
  trait :required_cb_fields do
    sequence(:headline) { |n| "Some Content #{n}" }
    body    { "Body for #{headline}" }
    status 5
  end

  trait :optional_cb_fields do
    sequence(:short_headline) { |n| "Short #{n}" }
    teaser  { "Teaser for #{headline}" }
  end
  
  trait :content_base do
    sequence(:published_at) { |n| Time.now - 60*60*n }
    required_cb_fields
  end
  
  trait :pending do
    status 3
    sequence(:published_at) { |n| Time.now + n.hours }
  end
  
  trait :published do
    status 5
    sequence(:published_at) { |n| Time.now - n.hours }
  end
  
  trait :draft do
    status 0
  end

# VideoShell ##########################################################
  factory :video_shell do
    content_base
    slug { headline.parameterize }
  end
  

# NewsStory #########################################################
  factory :news_story do
    content_base
    optional_cb_fields
    
    slug        { headline.parameterize }
    news_agency "KPCC"
    locale      "local"
  end


# ShowEpisode #########################################################
  factory :show_episode, aliases: [:episode] do
    content_base
    show
    sequence(:air_date) { |n| (Time.now + 60*60*24*n).strftime("%Y-%m-%d") }
  end


# ShowSegment #########################################################
  factory :show_segment, aliases: [:segment] do
    content_base
    optional_cb_fields
    show
    slug        { headline.parameterize }
    locale      "local"
  end

# ShowRundown #########################################################
  factory :show_rundown do
    episode
    segment
  end

# BlogEntry #########################################################
  factory :blog_entry do
    content_base
    optional_cb_fields 
    blog
    slug { headline.parameterize }
  end


# ContentShell #########################################################
  factory :content_shell do
    content_base
    site  "blogdowntown"
    url   { "http://blogdowntown.com/2011/11/6494-#{headline.parameterize}" }
  end
end