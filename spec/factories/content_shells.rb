FactoryGirl.define do
  factory :content_shell do
    sequence(:headline) { |n| "Some Content #{n}" }
    body    { "Body for #{headline}" }
    site "blogdowntown"
    url { "http://blogdowntown.com/2011/11/6494-#{headline.parameterize}" }

    published
  end
end
