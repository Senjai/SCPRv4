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
    is_news true
  end

  #-------------------------
  
  factory :blog_author do
    blog
    author
    sequence(:position)
  end

  factory :blog_entry do
    sequence(:headline) { |n| "Some Content #{n}" }
    sequence(:short_headline) { |n| "Short #{n}" }

    body    { "Body for #{headline}" }
    teaser  { "Teaser for #{headline}" }

    blog
    slug { headline.parameterize }

    published
  end
end
