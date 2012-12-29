##
# Data Points
#
FactoryGirl.define do
  factory :data_point do
    sequence(:data_key) { |i| "datapoint#{i}" }
  end
end
