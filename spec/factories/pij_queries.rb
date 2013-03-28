##
# PIJ Queries
#
FactoryGirl.define do
  factory :pij_query do
    sequence(:headline) { |n| "PIJ Query ##{n}"}
    body "Sweet PIJ query, bro"
    teaser { body }
    slug { headline.parameterize }  
    query_type "news"
    form_height 1500
    query_url "http://www.publicradio.org/applications/formbuilder/user/form_display.php"

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
end
