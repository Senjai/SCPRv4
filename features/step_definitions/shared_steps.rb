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