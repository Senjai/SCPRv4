#### Finders
Then /^I should see that there is nothing to list$/ do
  page.should have_css ".none-to-list"
end

Then /^I should see that there is nothing to list with the message "([^"]*)"$/ do |message|
  page.all(".none-to-list", text: message).should_not be_blank
end

Then /^there should be pagination$/ do
  page.should have_css ".pagination"
end

Then /^I should see static content$/ do
  page.should have_css ".static-content"
end

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

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content text
end

Then /^I should not see "([^"]*)"$/ do |text|
  page.should_not have_content text
end

#### Routing
When /^I go to the home page$/ do
  visit home_path
  current_path.should eq home_path
end


#### Assertions
When /^I'm looking at the "[^"]*" section$/ do
  true # This is just to provide context while reading the scenario, doesn't actually do anything.
end


#### Actions
When /^I filter by "([^"]*)"$/ do |filter|
  find("nav.filters").find_link(filter).click
end