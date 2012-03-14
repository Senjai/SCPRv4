Then /^I should see the name of the program in the broadcast bar$/ do
  page.find(".broadcastbar li.active-show-title").should have_content @program.title
end

Then /^I should see a headshot in the broadcast bar$/ do
  page.should have_css ".broadcastbar img.bbar_headshot"
end

Then /^I should see the episode guide$/ do
  page.should have_css ".broadcastbar li.show-summary"
end

Then /^I should not see the episode guide$/ do
  page.should_not have_css ".broadcastbar li.show-summary"
end
