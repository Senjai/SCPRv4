# Finders
Then /^I should see a missed it bucket$/ do
  page.should have_css ".missed-it-bucket"
end

Then /^the missed it bucket should have (\d+) items in it$/ do |num|
  page.find(".missed-it-bucket").should have_css ".missed-it-content li", count: num.to_i 
end

Then /^I should not see a missed it bucket$/ do
  page.should_not have_css ".missed-it-bucket"
end