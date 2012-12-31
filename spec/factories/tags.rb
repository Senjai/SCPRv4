##
# Tags
#
FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "Some Cool Slug #{n}"}
    slug { name.parameterize }
  end

  #-----------------------

  factory :tagged_content do
    # Content must be passed in
    tag
  end
end
