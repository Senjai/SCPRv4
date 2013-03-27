##
# Tickets
#
FactoryGirl.define do
  factory :ticket do
    user
    summary "Sweet Ticket, Bro"
    status 0
  end
end
