#### Setup
Given /^there (?:is|are) (\d+) upcoming events?$/ do |num|
  @events = create_list :event, num.to_i
  @event = @events[rand(@events.length)]
  Event.all.count.should eq num.to_i
  @closest_event = Event.closest
  @upcoming_events = Event.upcoming
end

Given /^there are (\d+) unpublished events$/ do |num|
  @unpublished_events = create_list :event, num.to_i, is_published: 0
end

Given /^there are (\d+) past events$/ do |num|
  @past_events = create_list :event, num.to_i, starts_at: 3.hours.ago, ends_at: 2.hours.ago
  Event.past.count.should eq num.to_i
end

Given /^each event has (\d+) assets?$/ do |num|
  @events.each do |event|
    create :asset, content: event
  end
end


#### Routing
When /^I go to the events page$/ do
  visit events_path
end


#### Finders
Then /^I should see the (\d+) closest events?$/ do |num|
  page.should have_css ".event", count: num.to_i
  page.first(".event").should have_content Event.upcoming.first.title
end

Then /^I should see (\d+) upcoming events?$/ do |num|
  page.should have_css ".event", count: num.to_i
end

Then /^I should not see any unpublished events$/ do
  @unpublished_events.each do |event|
    page.find(".upcoming-events").should_not have_content event.title
  end
end

Then /^I should not see any past events$/ do
  @past_events.each do |event|
    page.find(".upcoming-events").should_not have_content event.title
  end
end

Then /^I should see the closest event featured$/ do
  page.should have_css ".event.closest"
  page.find(".event.closest").should have_content Event.upcoming.first.title
end

Then /^I should see future events listed below the closest event$/ do
  page.should have_css ".event.future", count: @events.count - 1
end

Then /^the closest event should not be in the list of future events$/ do
  page.find(".future-events").should_not have_content @closest_event.title
end

Then /^I should see each event's primary asset$/ do
  page.should have_css ".upcoming-events .event .contentasset img", count: @upcoming_events.count
end

Then /^I should see a list of archived events in the archive strip$/ do
  page.should have_css(".archive-strip .event"), count: @past_events.first(3).count
end

