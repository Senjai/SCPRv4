# Finders
Then /^I should see a missed it bucket$/ do
  page.should have_css ".missed-it-bucket"
end

Then /^I should not see a missed it bucket$/ do
  page.should_not have_css ".missed-it-bucket"
end