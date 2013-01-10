##
# Flatpages
#
FactoryGirl.define do
  factory :flatpage do
    sequence(:url)        { |n| "/about-#{n}/" }
    title                 "About"
    content               "This is the about content"
    description           "This is the description"
    is_public             1
    template              "inherit"
  end
end
