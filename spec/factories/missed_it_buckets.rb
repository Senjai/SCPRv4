##
# Missed it Buckets
#
FactoryGirl.define do
  factory :missed_it_bucket do
    sequence(:title) { |n| "Airtalk #{n}" }
  end

  #-----------------------
  
  factory :missed_it_content do
    missed_it_bucket
    content { |mic| mic.association(:content_shell) }
  end
end
