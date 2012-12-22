##
# Sections
#
FactoryGirl.define do
  factory :section do
    sequence(:title)  { |n| "Section #{n}" }
    slug              { title.parameterize }
  end

  factory :section_blog do
    section
    blog
  end

  factory :section_category do
    section
    category
  end

  factory :section_promotion do
    section
    promotion
  end

  #--------------------------
  
  factory :promotion do
    sequence(:title)  { |n| "Promotion #{n}" }
    url               { "http://scpr.org/promotions/#{title.parameterize}" }
  end
end
