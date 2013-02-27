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
    published
  end

  trait :optional_cb_fields do
    sequence(:short_headline) { |n| "Short #{n}" }
    teaser  { "Teaser for #{headline}" }
  end

  trait :pending do
    status 3
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
    required_cb_fields
    slug { headline.parameterize }
  end
  

# NewsStory #########################################################
  factory :news_story do
    required_cb_fields
    optional_cb_fields
    slug { headline.parameterize }
  end


# ShowEpisode #########################################################
  factory :show_episode, aliases: [:episode] do
    required_cb_fields
    show
    sequence(:air_date) { |n| (Time.now + 60*60*24*n).strftime("%Y-%m-%d") }
  end


# ShowSegment #########################################################
  factory :show_segment, aliases: [:segment] do
    required_cb_fields
    optional_cb_fields
    show
    slug { headline.parameterize }
  end

# ShowRundown #########################################################
  factory :show_rundown do
    episode
    segment
  end

# BlogEntry #########################################################
  factory :blog_entry do
    required_cb_fields
    optional_cb_fields 
    blog
    slug { headline.parameterize }
  end


# ContentShell #########################################################
  factory :content_shell do
    required_cb_fields
    site "blogdowntown"
    url { "http://blogdowntown.com/2011/11/6494-#{headline.parameterize}" }
  end
end
