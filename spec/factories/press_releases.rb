##
# Press Releases
#
FactoryGirl.define do
  factory :press_release do
    sequence(:short_title) { |n| "Press Release #{n}" }
    slug { short_title.parameterize }
  end
end
