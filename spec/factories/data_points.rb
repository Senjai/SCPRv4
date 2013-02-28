##
# Data Points
#
FactoryGirl.define do
  factory :data_point do
    sequence(:data_key) { |i| "data_point_#{i}" }
    title { data_key.titleize }
  end
end
