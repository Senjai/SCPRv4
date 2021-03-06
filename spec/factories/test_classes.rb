Dir[Rails.root.join("spec/fixtures/models/*.rb")].each { |f| require f }

FactoryGirl.define do
  factory :test_class_story, class: TestClass::Story do
    sequence(:headline) { |n| "Cool Headline #{n}" }
    short_headline { "Short #{headline}" }
    body "Cool Body"
    teaser "Cool Teaser"
    slug { headline.parameterize }
    status ContentBase::STATUS_LIVE
    short_url "http://bit.ly/kpcc"

    trait :published do
      status ContentBase::STATUS_LIVE
    end

    trait :pending do
      status ContentBase::STATUS_PENDING
    end
  end

  factory :test_class_remote_story, class: TestClass::RemoteStory do
    headline "Cool Remote Headline"
    short_headline "Cool Remote Short Headline"
    body "Cool Remote Body"
    teaser "Cool Remote Teaser"
    slug { headline.parameterize }
    status ContentBase::STATUS_LIVE
    published_at { Time.now }
    remote_url "http://kpcc.org"
  end

  factory :test_class_post, class: TestClass::Post do
    headline "Cool AssetHeadline"
    short_headline "Cool Asset Short Headline"
    body "Cool Asset Body"
    teaser "Cool Asset Teaser"
    slug { headline.parameterize }
    status ContentBase::STATUS_LIVE
    published_at { Time.now }

    trait :published do
      status ContentBase::STATUS_LIVE
    end

    trait :pending do
      status ContentBase::STATUS_PENDING
    end
  end

  factory :test_class_post_content, class: TestClass::PostContent do
    test_class_thing_with_asset
  end

  factory :test_class_person, class: TestClass::Person do
    name "Bryan"
    slug { name.parameterize }
  end

  factory :test_class_fake_audio, class: TestClass::FakeAudio do
    path { File.join(self.store_dir, self.filename) }

    trait :live do
      status Audio::STATUS_LIVE
    end

    trait :pending do
      status Audio::STATUS_WAIT
    end
  end
end
