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

Then /^I should see a success message$/ do
  page.should have_css ".alert-success"
end

Then /^I should see a failure message$/ do
  page.should have_css ".alert-error"
end

Then /^I should be notified of errors$/ do
  page.should have_css ".error"
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content text
end

Then /^I should not see "([^"]*)"$/ do |text|
  page.should_not have_content text
end

# This assumes that the ID of the form uses underscores, which is how FormBuilder does it by default.
Then /^I should see (an?|the) "([^"]*)" (?:section|form)$/ do |selector, text|
  s = %w{a an}.include?(selector) ? [".", "-"] : ["#", "_"]
  @css_finder = s[0] + text.gsub(/\s/, s[1])
  page.should have_css @css_finder
end



#### Routing
When /^I go to the home page$/ do
  create(:homepage) unless Homepage.published.present?
  visit home_path
  current_path.should eq home_path
end

When /^I go to "([^"]*)"$/ do |path|
  visit Rails.application.routes.url_helpers.send(path.gsub("\s", "_") + "_path")
end

Then /^I should be on "([^"]*)"$/ do |path|
  current_path.should eq Rails.application.routes.url_helpers.send(path.gsub("\s", "_") + "_path")
end

#### Assertions
When /^I'm looking at the "[^"]*" section$/ do
  true # This is just to provide context while reading the scenario, doesn't actually do anything.
end

Then /^that section should have (\d+) items$/ do |num|
  page.find(@css_finder + " ul").should have_css "li", count: num.to_i
end



#### Actions
When /^I filter by "([^"]*)"$/ do |filter|
  find("nav.filters").find_link(filter).click
end

# This assumes that the ID of the form uses underscores, which is how FormBuilder does it by default.
When /^I submit the "([^"]*)" form$/ do |text|
  page.find("form##{text.gsub(/\s/, "_")} input[type=submit]").click
end

