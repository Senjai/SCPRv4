# Comments
Then /^I should see (?:a|the) comments? section$/ do
  page.should have_css "#comments"
end


# Related
Then /^I should see (\d+) related articles$/ do |num|
  page.should have_css ".related-articles li", count: num.to_i
end

Then /^I should see (\d+) related links$/ do |num|
  page.should have_css ".related-links li", count: num.to_i
end


# Video
Then /^I should see a video$/ do
  page.should have_css "object.BrightcoveExperience"
end

Then /^I should not see a video$/ do
  page.should_not have_css "object.BrightcoveExperience"
end
