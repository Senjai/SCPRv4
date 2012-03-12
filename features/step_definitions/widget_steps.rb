Then /^I should see a comments section$/ do
  page.should have_css "#comments"
end

Then /^I should see related content$/ do
  page.should have_css ".related-articles"
end

Then /^I should see related links$/ do
  pending
end