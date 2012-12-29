##
# Assets
#
FactoryGirl.define do
  factory :asset, class: ContentAsset do
    sequence(:id, 1)
    sequence(:asset_order, 1)
    asset_id 33585 # Doesn't matter what this is because the response gets mocked
    sequence(:caption) { |n| "Caption #{n}" }
    content { |asset| asset.association :content_shell }
  end
end
