#### Finders
Then /^I should see (\d+) more upcoming events listed$/ do |num|
  page.should have_css ".more-events .event", count: num.to_i
end

Then /^that event should not be in the upcoming events$/ do
  find(".more-events").should_not have_content @event.headline
end
