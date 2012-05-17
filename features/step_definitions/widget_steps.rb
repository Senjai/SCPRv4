# Comments
Then /^I should see (?:a|the) comments? section$/ do
  page.should have_css "#comments"
end

Then /^I should not see (?:a|the) comments? section$/ do
  page.should_not have_css "#comments"
end



# Related
Then /^I should see (\d+) related articles$/ do |num|
  page.should have_css ".related-articles li", count: num.to_i
end

Then /^I should see (\d+) related links$/ do |num|
  page.should have_css ".related-links li", count: num.to_i
end




# Generic
Then /^I should see the "([^"]*)" widget$/ do |text|
  widget = text.gsub(/\s+/, "-") # recent posts > recent-posts
  page.should have_css ".widget.#{widget}"
end

Then /^I should not see the "([^"]*)" widget$/ do |text|
  widget = text.gsub(/\s+/, "-") # recent posts > recent-posts
  page.should_not have_css ".widget.#{widget}"
end


# Video
Then /^I should see a video$/ do
  page.should have_css "object.BrightcoveExperience"
end

Then /^I should not see a video$/ do
  page.should_not have_css "object.BrightcoveExperience"
end



# Article Meta
Then /^the article meta header should say "([^"]*)"$/ do |text|
  page.find(".article-meta").should have_content "#{text}"
end

Then /^I should see article meta$/ do
  page.should have_css ".article-meta"
end

# Audio
Then /^I should see an audio link$/ do
  page.should have_css ".audio-toggler"
end

Then /^I should not see an audio link$/ do
  page.should_not have_css ".audio-toggler"
end



# Maps
Then /^I should see a map$/ do
  page.should have_css ".map-canvas"
end

Then /^I should see a link to open the map$/ do
  page.should have_css ".map-link"
end

Then /^I should not see a map$/ do
  page.should_not have_css ".map-canvas"
end

Then /^I should not see a link to open the map$/ do
  page.should_not have_css ".map-link"
end