##
# Editions
#
FactoryGirl.define do
  factory :edition do
    status 5

    trait :published do
      sequence(:published_at) { |n| Time.now + n.hours }
    end

    trait :unpublished do
      status 1
    end
  end

  factory :edition_slot do
    edition
    item { |f| f.association(:abstract) }
    position 0
  end
end
