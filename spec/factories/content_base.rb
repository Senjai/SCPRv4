FactoryGirl.define do
  
##########################################################
### ContentBase Classes
##### *NOTE:* The name of the factory should eq `ClassName.to_s.underscore.to_sym`, i.e. NewsStory = :news_story
##### This is to please `#make_content` / `#sphinx_spec` in /spec/support/content_base_helpers.rb
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
    ignore { asset_count    0 }
    ignore { link_count     0 }
    ignore { brel_count     0 }
    ignore { frel_count     0 }
    ignore { with_category  false }
    ignore { byline_count   0 }
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
    
    slug    { headline.parameterize }
    
    ignore  { related_factory  "content_shell" }
    ignore  { category_type    :category_not_news }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end
  

# NewsStory #########################################################
  factory :news_story do
    content_base
    optional_cb_fields
    
    slug        { headline.parameterize }
    news_agency "KPCC"
    locale      "local"
    
    ignore { related_factory  "content_shell" }
    ignore { category_type    :category_news }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end


# ShowEpisode #########################################################
  factory :show_episode, aliases: [:episode] do
    content_base
    show
    
    sequence(:air_date) { |n| (Time.now + 60*60*24*n).strftime("%Y-%m-%d") }
    
    ignore { segment_count    0 }
    ignore { related_factory  "content_shell" }
    ignore { category_type    nil }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
      segments = FactoryGirl.create_list(:show_segment, evaluator.segment_count.to_i, show: object.show)
      segments.each { |segment| segment.episodes << object }
    end
  end


# ShowSegment #########################################################
  factory :show_segment, aliases: [:segment] do
    content_base
    optional_cb_fields
    show
    
    slug        { headline.parameterize }
    locale      "local"

    ignore { related_factory  "content_shell" }
    ignore { category_type    :category_news }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end


# BlogEntry #########################################################
  factory :blog_entry do
    content_base
    optional_cb_fields 
    blog
    
    slug      { headline.parameterize }
    blog_slug { blog.slug }

    ignore { related_factory      "content_shell" }
    ignore { category_type        :category_not_news }
    ignore { tag_count            0 }
    ignore { blog_category_count  0 }

    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
      FactoryGirl.create_list :tagged_content, evaluator.tag_count.to_i, content: object
      FactoryGirl.create_list :blog_entry_blog_category, evaluator.blog_category_count.to_i, blog_entry: object
    end
  end


# ContentShell #########################################################
  factory :content_shell do
    content_base
    
    site  "blogdowntown"
    url   { "http://blogdowntown.com/2011/11/6494-#{headline.parameterize}" }
    
    ignore { related_factory  "video_shell" }
    ignore { category_type    :category_news }

    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end
end