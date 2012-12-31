##
# Related
#
FactoryGirl.define do
  factory :related_content, class: Related do
    sequence(:id, 1)

    factory :outgoing_reference do
      related { |brel| brel.association(:content_shell) } #TODO Need to be able to pass in any type of factory here
    end

    factory :incoming_reference do
      content { |frel| frel.association(:content_shell) } #TODO Need to be able to pass in any type of factory here
    end
  end

  #----------------------------
  
  factory :link do
    sequence(:id, 1)
    title     "A Related Link"
    link      "http://oncentral.org"
    link_type "website"
  end
end
