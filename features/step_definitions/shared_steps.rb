Then /^I should see that there is nothing to list with the message "([^"]*)"$/ do |message|
  find(".none-to-list").should have_content message
end
