Then /^I should see the name of the program in the broadcast bar$/ do
  page.find(".broadcast-bar .current.program").should have_content @program.title
end

Then /^I should see a headshot in the broadcast bar$/ do
  page.should have_css ".broadcast-bar a.headshot"
end

Then /^I should see the episode guide$/ do
  page.should have_css ".broadcast-bar .episode-guide"
end

Then /^I should not see the episode guide$/ do
  page.should_not have_css ".broadcast-bar .episode-guide"
end
