def content_base_associations(object, evaluator)
  FactoryGirl.create_list(:asset, evaluator.asset_count.to_i, content: object)
  FactoryGirl.create_list(:link, evaluator.link_count.to_i, content: object)
  FactoryGirl.create_list(:brel, evaluator.brel_count.to_i, content: object)
  FactoryGirl.create_list(:frel, evaluator.frel_count.to_i, related: object)
  FactoryGirl.create_list(:byline, evaluator.byline_count.to_i, content: object)
  
  if evaluator.category_type.present? && evaluator.with_category
    category = FactoryGirl.create(evaluator.category_type)
    FactoryGirl.create(:content_category, content: object, category: category)
  end
end

FactoryGirl.define do

### Common Attributes
trait :sequenced_published_at do
  sequence(:published_at) { |n| Time.now + 60*60*n }
end


# Schedule #########################################################
  factory :schedule do # Requires us to pass in kpcc_proram_id or other_program_id and program. There must be a better way to do this.
    sequence(:day) { |n| (Time.now + 60*60*24*n).day }
    start_time "00:00:00" # arbitrary
    end_time "02:00:00" # aribtrary
    sequence(:program) { |n| "Cool Program #{n}" } 
    url { "/programs/#{program.parameterize}" }
    kpcc_program_id 1
  end
  

# User #########################################################
  factory :bio, class: "Bio", aliases: [:author] do
    bio "This is a bio"
    short_bio "Short!"
    name "Bryan Ricker"
    last_name "Ricker"
    email { "#{name.parameterize}@kpcc.org" }
    is_public true
    slugged_name { name.parameterize }
    title "Rails Developer"
    twitter { "@#{slugged_name}" }
    sequence(:user_id)
    phone_number "123-456-7890"
  end
  
# AdminUser #########################################################
  factory :admin_user do
    # To be removed:
    first_name "Bryan"
    last_name "Ricker"
    password "sha1$vxA3aP5quIgd$aa7c53395bf8d6126c02ec8ef4e8a9b784c9a2f7" # `secret`, salted & digested
    date_joined { Time.now }
    #
    
    unencrypted_password "secret"
    unencrypted_password_confirmation { unencrypted_password }
    last_login { Time.now }
    sequence(:email) { |i| "user#{i}@scpr.org" }
    is_staff 1
    is_active 1
    is_superuser 1
  end
  

# KpccProgram #########################################################
  factory :kpcc_program, aliases: [:show] do
    sequence(:title) { |n| "Show #{n}" }
    slug { title.parameterize }
    quick_slug { title.parameterize.chars.first(5) }
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
    
    ignore { segment Hash.new } # Ensures that `merge` has something to do in the after :create block
    ignore { episode Hash.new } # Ensures that `merge` has something to do in the after :create block
    ignore { missed_it_bucket Hash.new }
    ignore { episode_count 0 }
    ignore { segment_count 0 }
    ignore { blog false }
    
    after :create do |object, evaluator|
      FactoryGirl.create_list(:show_segment, evaluator.segment_count.to_i, evaluator.segment.merge!(show: object))
      FactoryGirl.create_list(:show_episode, evaluator.episode_count.to_i, evaluator.episode.merge!(show: object))
      
      if evaluator.blog == "true"
        object.blog = FactoryGirl.create :blog
        object.save!
      end
      
      if evaluator.missed_it_bucket_id.blank?
        object.missed_it_bucket = FactoryGirl.create(:missed_it_bucket, evaluator.missed_it_bucket.reverse_merge!(title: object.title))
        object.save!
      end
    end
  end
  

# OtherProgram #########################################################
  factory :other_program do
    sequence(:title) { |n| "Other Program #{n}" }
    slug { title.parameterize }
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
  

# ShowRundown #########################################################
  factory :show_rundown do
    episode
    segment
  end

# Podcast #########################################################
  factory :podcast do
    sequence(:title) { |n| "Podcast #{n}" }
    slug { title.parameterize }
    is_listed 1
    author "KPCC 89.3 | Southern California Public Radio"
    program { |p| p.association :kpcc_program }
    item_type 'episodes'
    image_url { "http://media.scpr.org/assets/images/podcasts/#{slug}.png" }
    keywords "KPCC, Los Angeles, Southern California, LA"
    link { "http://www.scpr.org/programs/#{slug}" }
    duration 0 # Needs to be removed from database
  end


# Blog #########################################################
  factory :blog do
    sequence(:name) { |n| "Blog #{n}" }
    slug { name.parameterize }
    teaser { "This is the teaser for #{name}!" }
    description "This is a description for this blog."
    head_image "http://media.scpr.org/assets/images/heads/larry_transparent.png"
    is_active true
    is_remote false
    is_news true
    feed_url "http://oncentral.org/rss/latest"
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
    
    ignore { author_count 0 }
    ignore { entry_count 0 }
    ignore { entry Hash.new }
    ignore { missed_it_bucket Hash.new }
  
    after :create do |object, evaluator|
      FactoryGirl.create_list(:blog_entry, evaluator.entry_count.to_i, evaluator.entry.merge!(blog: object))
      FactoryGirl.create_list(:blog_author, evaluator.author_count.to_i, blog: object)
      
      if evaluator.missed_it_bucket_id.blank?
        object.missed_it_bucket = FactoryGirl.create(:missed_it_bucket, evaluator.missed_it_bucket.reverse_merge!(title: object.name))
        object.save!
      end
    end
  end

# BreakingNewsAlert #########################################################
  factory :breaking_news_alert do
    headline "Breaking news!"
    teaser "This is breaking news"
    alert_time { Time.now }
    alert_type "break"
    alert_link "http://scpr.org/"
    is_published 1
    visible 1
    email_sent 0
    send_email 0
  end

# BlogAuthor #########################################################
  factory :blog_author do
    blog
    author
    sequence(:position)
  end

  
# Event #########################################################
  factory :event do
    sequence(:id, 1) # Not auto-incrementing in database?
    sequence(:headline) { |n| "A Very Special Event #{n}" }
    slug { headline.parameterize }
    body "This is a very special event."
    etype "comm" # This is actually "type" in mercer
    sponsor "Patt Morrison"
    sponsor_link "http://oncentral.org"
    sequence(:starts_at) { |n| Time.now + 60*60*24*n }
    ends_at { starts_at + 60*60*1 }
    is_all_day 0
    location_name "The Crawford Family Forum"
    location_link "http://www.scpr.org/crawfordfamilyforum"
    rsvp_link "http://kpcc.ticketleap.com/connie-rice/"
    show_map 1
    address_1 "474 South Raymond Avenue"
    address_2 "Second Level" # required column?
    city "Pasadena"
    state "CA"
    zip_code "91105"
    for_program "airtalk"
    audio "audio/events/2011/05/23/Father_Boyle.mp3"
    archive_description "This is the description that shows after the event has happened"
    is_published 1
    show_comments 1
    teaser "This is a short teaser"

    trait :multiple_days_past do
      starts_at { 3.days.ago }
      ends_at   { 1.day.ago }
    end
    
    trait :multiple_days_current do
      starts_at { 1.day.ago }
      ends_at   { 1.day.from_now }
    end
    
    trait :multiple_days_future do
      starts_at { 1.day.from_now }
      ends_at   { 3.days.from_now }
    end
    
    trait :past do
      starts_at { 3.hours.ago }
      ends_at   { 2.hours.ago }
    end
    
    trait :current do
      sequence(:starts_at) { |n| n.hours.ago }
      sequence(:ends_at)   { |n| n.hours.from_now }
    end
    
    trait :future do
      starts_at { 2.hours.from_now }
      ends_at   { 3.hours.from_now }
    end
      
    ignore { asset_count 0 }
    after :create do |event, evaluator|
      FactoryGirl.create_list(:asset, evaluator.asset_count.to_i, content: event)
    end
  end

# ContentEmail#########################################################
  factory :content_email do # Must pass in content
    from_email  "bricker@kpcc.org"
    to_email    "bricker@scpr.org"
    content { |email| email.association :content_shell }
  end

# ContentAsset#########################################################
  factory :asset, class: ContentAsset do
    sequence(:id, 1)
    sequence(:asset_order, 1)
    asset_id 33585 # Doesn't matter what this is because the response gets mocked
    sequence(:caption) { |n| "Caption #{n}" }
    content { |asset| asset.association :content_shell }
  end


# ContentByline #########################################################
  factory :byline, class: "ContentByline", aliases: [:content_byline] do # Requires we pass in "content"
    role ContentByline::ROLE_PRIMARY
    user { |byline| byline.association :author }
    content { |byline| byline.association(:news_story) } #TODO Need to be able to pass in any type of factory here
    name "Dan Jones"
  end

  
# Category #########################################################
  factory :category do
    trait :is_news do 
      sequence(:category) { |n| "Local #{n}" }
      is_news true
    end

    trait :is_not_news do
      sequence(:category) { |n| "Culture #{n}" }
      is_news false
    end

    slug { category.parameterize }
    comment_bucket

    factory :category_news, traits: [:is_news]
    factory :category_not_news, traits: [:is_not_news]
    
    ignore { content_count 0 }
    ignore { content Hash.new }
    
    after :create do |object, evaluator|
      FactoryGirl.create_list(:news_story, evaluator.content_count.to_i, evaluator.content.merge!(category: object))
    end
  end


# BlogCategory #########################################################
  factory :blog_category do
    blog
    sequence(:title) { |n| "Category #{n}" }
    slug { title.parameterize }
    
    ignore { entry_count 0 }
    
    after :create do |object, evaluator|
      FactoryGirl.create_list(:blog_entry_blog_category, evaluator.entry_count.to_i, blog_category: object)
    end
  end
  
# BlogEntryBlogCategory #########################################################
  factory :blog_entry_blog_category do
    blog_category
    blog_entry
  end
  
  
# Tag #########################################################
  factory :tag do
    sequence(:name) { |n| "Some Cool Slug #{n}"}
    slug { name.parameterize }
  end

# TaggedContent #########################################################
  factory :tagged_content do
    # Content must be passed in
    tag
  end
    

# FeaturedCommentBucket #########################################################
  factory :featured_comment_bucket, aliases: [:comment_bucket] do
    title "Comment Bucket"
  end
  
  
# FeaturedComment #########################################################
  factory :featured_comment do
    featured_comment_bucket
    status 5
    sequenced_published_at
    username "bryanricker"
    excert "This is an excerpt of the featured comment"
    content { |mic| mic.association(:content_shell) }
  end
  
  
# Flatpage #########################################################
  factory :flatpage do
    url "/about/"
    title "About"
    content "This is the about content"
    enable_comments 0
    registration_required 0
    description "This is the description"
    is_public 1
    template ""
  end


# Section #########################################################
  factory :section do
    sequence(:title)  { |n| "Section #{n}" }
    slug              { title.parameterize }    
  end
  
  factory :section_blog do
    section
    blog
  end
  
  factory :section_category do
    section
    category
  end
  
  factory :section_promotion do
    section
    promotion
  end

  
# Promotion #########################################################
  factory :promotion do
    sequence(:title)  { |n| "Promotion #{n}" }
    url               { "http://scpr.org/promotions/#{title.parameterize}" }
  end
  

# ContentCategory #########################################################
  factory :content_category do
    # Empty, forcing us to pass content and category every time we create one
  end

# Related #########################################################
factory :related_content, class: Related do
  sequence(:id, 1)

  factory :brel do # "brels" - needs content
    flag 0
    related { |brel| brel.association(:content_shell) } #TODO Need to be able to pass in any type of factory here
  end

  factory :frel do # "frels" - needs related
    flag 0
    content { |frel| frel.association(:content_shell) } #TODO Need to be able to pass in any type of factory here
  end
end
  
# Link #########################################################
  factory :link do
    sequence(:id, 1)
    title "A Related Link"
    link "http://oncentral.org"
    link_type "website"
  end

# Homepage #########################################################
factory :homepage do
  base "default"
  sequenced_published_at
  status 5
  
  ignore { missed_it_bucket Hash.new }
  ignore { contents_count 0 }
  
  after :create do |object, evaluator|
    FactoryGirl.create_list(:homepage_content, evaluator.contents_count.to_i, homepage: object)
    
    if evaluator.missed_it_bucket_id.blank?
      object.missed_it_bucket = FactoryGirl.create(:missed_it_bucket, evaluator.missed_it_bucket.reverse_merge!(title: "Homepage #{object.id}"))
      object.save!
    end
  end
end

# HomepageContent #########################################################
factory :homepage_content do
  homepage
  content { |hc| hc.association(:content_shell) }
end

# MissedItBucket #########################################################
factory :missed_it_bucket do
  title "Airtalk"
  ignore { contents_count 0 }
  after :create do |object, evaluator|
    FactoryGirl.create_list(:missed_it_content, evaluator.contents_count.to_i, missed_it_bucket: object)
  end
end

# MissedItContent #########################################################
factory :missed_it_content do
  missed_it_bucket
  content { |mic| mic.association(:content_shell) }
end

# PijQuery #########################################################
factory :pij_query do
  sequence(:headline) { |n| "PIJ Query ##{n}"}
  slug        { headline.parameterize }
  query_url   "http://www.publicradio.org/applications/formbuilder/user/form_display.php?isPIJ=Y&form_code=2dc7d243ce2c"
  form_height "2300"
  
  # Defaults
  is_featured   false
  is_active     true
  published_at  { 1.day.ago }
  query_type    "news"
    
  trait :utility do
    query_type "utility"
  end
  
  trait :evergreen do
    query_type "evergreen"
  end
  
  trait :news do
    query_type "news"
  end
  
  trait :featured do
    is_featured true
  end
  
  trait :visible do
    is_active true
    published_at  { 1.day.ago }
    expires_at    { 1.day.from_now }
  end
  
  trait :inactive do
    is_active     false
    published_at  { 1.day.ago }
    expires_at    { 1.day.from_now }
  end
  
  trait :unpublished do
    is_active     true
    published_at  { 1.day.from_now }
    expires_at    { 2.days.from_now }
  end
  
  trait :expired do
    is_active     { true }
    published_at  { 2.days.ago }
    expires_at    { 1.day.ago }
  end
end

##########################################################
### ContentBase Classes
##### *NOTE:* The name of the factory should eq `ClassName.to_s.underscore.to_sym`, i.e. NewsStory = :news_story
##### This is to please `#make_content` / `#sphinx_spec` in /spec/support/content_base_helpers.rb
##########################################################

# ContentBase - Common attributes ##########################################################
  trait :required_cb_fields do
    sequence(:headline) { |n| "Some Content #{n}" }
    body    { "Body for #{headline}" }
  end

  trait :optional_cb_fields do
    sequence(:short_headline) { |n| "Short #{n}" }
    teaser  { "Teaser for #{headline}" }
  end
  
  trait :content_base do
    ignore { asset_count 0 }
    ignore { link_count 0 }
    ignore { brel_count 0 }
    ignore { frel_count 0 }
    ignore { with_category false }
    ignore { byline_count 0 }
    status 5
    sequence(:published_at) { |n| Time.now - 60*60*n }
    required_cb_fields
  end
    

# VideoShell ##########################################################
  factory :video_shell do
    content_base
    
    slug { headline.parameterize }
    
    ignore { related_factory "content_shell" }
    ignore { category_type :category_not_news }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end
  

# NewsStory #########################################################
  factory :news_story do
    content_base
    optional_cb_fields
    
    slug { headline.parameterize }
    news_agency "KPCC"
    locale "local"
    
    ignore { related_factory "content_shell" }
    ignore { category_type :category_news }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end


# ShowEpisode #########################################################
  factory :show_episode, aliases: [:episode] do
    content_base
    show
    
    sequence(:air_date) { |n| (Time.now + 60*60*24*n).strftime("%Y-%m-%d") }
    
    ignore { segment_count 0 }
    ignore { related_factory "content_shell" }
    ignore { category_type nil }
    
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
    
    slug { headline.parameterize }
    locale "local"
    audio_date { Time.now }
    enco_number 999

    ignore { related_factory "content_shell" }
    ignore { category_type :category_news }
    
    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end


# BlogEntry #########################################################
  factory :blog_entry do
    content_base
    optional_cb_fields 
    author
    blog
    
    slug { headline.parameterize }
    blog_slug { blog.slug }

    ignore { related_factory "content_shell" }
    ignore { category_type :category_not_news }
    ignore { tag_count 0 }
    ignore { blog_category_count 0 }

    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
      FactoryGirl.create_list :tagged_content, evaluator.tag_count.to_i, content: object
      FactoryGirl.create_list :blog_entry_blog_category, evaluator.blog_category_count.to_i, blog_entry: object
    end
  end


# ContentShell #########################################################
  factory :content_shell do
    content_base
    
    site "blogdowntown"
    url { "http://blogdowntown.com/2011/11/6494-#{headline.parameterize}" }
    
    ignore { related_factory "video_shell" }
    ignore { category_type :category_news }

    after :create do |object, evaluator|
      content_base_associations(object, evaluator)
    end
  end
end