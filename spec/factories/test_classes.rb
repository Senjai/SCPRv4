require Rails.root.join("spec/fixtures/test_class")

FactoryGirl.define do
  factory :test_class_story, class: TestClass::Story do
    sequence(:headline) { |n| "Cool Headline #{n}" }
    short_headline { "Short #{headline}" }
    body "Cool Body"
    teaser "Cool Teaser"
    slug { headline.parameterize }
    status 5
  end
  
  factory :test_class_remote_story, class: TestClass::RemoteStory do
    headline "Cool Remote Headline"
    short_headline "Cool Remote Short Headline"
    body "Cool Remote Body"
    teaser "Cool Remote Teaser"
    slug { headline.parameterize }
    status 5
    published_at { Time.now }
  end
  
  factory :test_class_post, class: TestClass::Post do
    headline "Cool AssetHeadline"
    short_headline "Cool Asset Short Headline"
    body "Cool Asset Body"
    teaser "Cool Asset Teaser"
    slug { headline.parameterize }
    status 5
    published_at { Time.now }
  end
  
  factory :test_class_post_content, class: TestClass::PostContent do
    test_class_thing_with_asset
  end
  
  factory :test_class_person, class: TestClass::Person do
    name "Bryan"
    slug { name.parameterize }
  end
end
