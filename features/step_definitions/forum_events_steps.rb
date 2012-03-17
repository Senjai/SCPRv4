#### Setup
Given /^there (?:is|are) (\d+) upcoming forum events?$/ do |num|
  @events = create_list :event, num.to_i
  @event = @events[rand(@events.length)]
  Event.all.count.should eq num.to_i
end

Given /^each event has (\d+) assets?$/ do |num|
  @events.each do |event|
    create :asset, content: event
  end
end


#### Routing
When /^I go to the forum page$/ do
  visit forum_events_path
  current_path.should eq forum_events_path
end


#### Finders
Then /^I should see the (\d+) closest events?$/ do |num|
  page.should have_css ".event", count: num.to_i
  page.first(".upcoming-events .event").should have_content Event.forum.upcoming.first.title
end

Then /^I should see the closest event featured$/ do
  page.should have_css ".event.closest"
  page.find(".event.closest").should have_content Event.forum.upcoming.first.title
end

Then /^I should see future events listed below the closest event$/ do
  page.should have_css ".event.future", count: @events.count - 1
end

Then /^the closest event should not be in the list of future events$/ do
  page.find(".future-events").should_not have_content Event.forum.closest.title
end

Then /^I should see a list of archived events in the archive strip$/ do
  page.should have_css(".archive-strip .event"), count: Event.forum.past.first(3).count
end

