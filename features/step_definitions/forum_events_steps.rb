#### Setup
Given /^there (?:is|are) (\d+) upcoming forum events?$/ do |num|
  @events = create_list :event, num.to_i
  @event = @events[rand(@events.length)]
  Event.all.count.should eq num.to_i
end


#### Routing
When /^I go to the forum page$/ do
  visit forum_events_path
  current_path.should eq forum_events_path
end

When /^I go to the forum archive page$/ do
  visit forum_events_archive_path
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

Then /^I should only see forum events$/ do
  non_forum_events = Event.all - Event.sponsored.all
  non_forum.events.each do |event|
    page.should_not match event.title
  end
end

Then /^I should see (\d+) more upcoming events listed$/ do |num|
  page.should have_css ".more-events .event", count: num.to_i
end

Then /^that event should not be in the upcoming events$/ do
  find(".more-events").should_not have_content @event.title
end



#### Assertions
Then /^the events should be ordered by "([^"]*)"$/ do |order|
  pending "Need to figure this one out"
  # events = Event.order(order)
  # page.first(".event").should match events.first
  # page.last(".event").should match events.last
  # Event.forum.past.order(order).each_with_index do |event, i|
  #   page.find(".event")[i].should have_content event.title
  # end
end


#### Actions
When /^I click on "([^"]*)" in the navigation$/ do |text|
  page.find("nav.events").click_link(text)
end
