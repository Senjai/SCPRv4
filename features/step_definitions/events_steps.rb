#### Setup
Given /^(?:an )?events? with the following attributes?:$/ do |table|
  events = []
  table.hashes.each do |attributes|
    attributes["starts_at"] = Chronic.parse(attributes["starts_at"]) if attributes["starts_at"].present?
    events << create(:event, attributes)
  end
  events.count.should eq table.hashes.count
  @event = events[rand(events.count)]
end

Given /^there (?:is|are) (\d+) events?$/ do |num|
  @events = create_list :event, num.to_i
end


#### Finders
Then /^I should see "([^"]*)" events ordered by "([^"]*)"$/ do |list, order|
  Event.published.order(order).send(list.to_sym).each_with_index do |event, i|
    page.find(".event-teaser")[i].should have_content event.title 
  end
end

Then /^I should see (\d+) events$/ do |num|
  if num.to_i == 0
    page.should_not have_css ".event"
  else
    page.should have_css ".event", count: num.to_i
  end
end

Then /^I should see a list of (\d+) upcoming events$/ do |num|
  Event.upcoming.limit(num.to_i).each_with_index do |event|
    page.should have_content event.title
  end
end

Then /^I should see a list of (\d+) upcoming "([^"]*)" events$/ do |num, list|
  Event.upcoming.limit(num.to_i).send(list.to_sym).each_with_index do |event|
    page.should have_content event.title
  end
end

Then /^I should see (\d+) unpublished events$/ do |num|
  Event.limit(num.to_i).where(is_published: false).each do |event|
    page.should match event.title
  end
end

Then /^I should see (\d+) past events$/ do |num|
  if num.to_i == 0
    page.should_not have_css ".past-events .event"
  else
    page.should have_css ".past-events .event", count: num.to_i
  end
  # Event.limit(num.to_i).past.forum.each_with_index do |event, i|
  #   page.find(".past-events .event")[i].should have_content event.title
  # end
end

Then /^I should see (\d+) past events in "([^"]*)"$/ do |num, text|
  if num.to_i == 0
    page.find(".#{text.gsub(/ /,"-")}").should_not have_css ".past-events .event"
  else
    page.find(".#{text.gsub(/ /,"-")}").should have_css ".past-events .event", count: num.to_i
  end
  # Event.limit(num.to_i).past.forum.each_with_index do |event, i|
  #   page.find(".past-events .event")[i].should have_content event.title
  # end
end

Then /^I should see each event's primary asset$/ do
  page.should have_css ".upcoming-events .event .contentasset img", count: Event.all.count
end

Then /^I should see an RSVP link$/ do
  page.should have_css "#rsvp-btn"
end

Then /^I should not see an RSVP link$/ do
  page.should_not have_css "#rsvp-btn"
end

Then /^I should see that even has already occurred$/ do
  page.should have_css ".past-date"
end

#### Routing
When /^I go to the events page$/ do
  visit events_path
end

When /^I go to (?:that|the|an) event's page$/ do
  visit @event.link_path
end

When /^I go to an event page for an event that doesn't exist$/ do
  visit event_path(year: 1, month: 2, day: 3, slug: "doesnt-exist")
end

Then /^I should be redirected to the events page$/ do
  current_path.should eq events_path
end

