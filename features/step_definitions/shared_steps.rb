Then /^I should see that there is nothing to list$/ do
  page.should have_css ".none-to-list"
end

Then /^I should see that there is nothing to list with the message "([^"]*)"$/ do |message|
  page.all(".none-to-list", text: message).should_not be_blank
end

When /^I go to the home page$/ do
  visit home_path
  current_path.should eq home_path
end
