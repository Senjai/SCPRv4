##
# Bylines
#
FactoryGirl.define do
  factory :byline, class: "ContentByline", aliases: [:content_byline] do # Requires we pass in "content"
    role    ContentByline::ROLE_PRIMARY
    content { |byline| byline.association(:news_story) } #TODO Need to be able to pass in any type of factory here
    name    "Dan Jones"
  end
end
