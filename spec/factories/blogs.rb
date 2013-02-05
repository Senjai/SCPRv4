##
# Blogs
#
FactoryGirl.define do  
  factory :blog do
    sequence(:name) { |n| "Blog #{n}" }
    slug { name.parameterize }
    teaser { "This is the teaser for #{name}!" }
    description "This is a description for this blog."
    is_active true
    is_remote false
    is_news true
    feed_url "http://oncentral.org/rss/latest"
    custom_url "http://scpr.org" # it's a required field?

    trait :remote do
      is_remote true
      feed_url "http://oncentral.org/rss/latest"
    end
  end

  #-------------------------
  
  factory :blog_author do
    blog
    author
    sequence(:position)
  end
end
