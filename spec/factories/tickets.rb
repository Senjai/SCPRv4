##
# Tickets
#
FactoryGirl.define do
  factory :ticket do
    user
    summary "Sweet Ticket, Bro"
    status 1
  end
end
