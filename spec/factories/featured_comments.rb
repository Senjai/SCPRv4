##
# Featured Comments
#
FactoryGirl.define do
  factory :featured_comment_bucket, aliases: [:comment_bucket] do
    sequence(:title) { |n| "Comment Bucket #{n}" }
  end

  #---------------------------
  
  factory :featured_comment do
    bucket  { |f| f.association :featured_comment_bucket }
    content { |mic| mic.association(:content_shell) }

    username  "bryanricker"
    excerpt   "This is an excerpt of the featured comment"

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
  end
end
