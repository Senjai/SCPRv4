Then /^I should see that there is nothing to list with the message "([^"]*)"$/ do |message|
  page.all(".none-to-list", text: message).should_not be_blank
end
