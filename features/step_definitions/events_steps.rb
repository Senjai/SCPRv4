#### Setup
Given /^the following events:$/ do |table|
  @events = []
  table.hashes.each do |attributes|
    attributes["starts_at"] = Chronic.parse(attributes["starts_at"]) if attributes["starts_at"].present?
    @events << create(:event, attributes)
  end
  Event.count.should eq table.hashes.count
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
  page.should have_css ".upcoming-events .event .contentasset img", count: @events.count
end


#### Routing
When /^I go to the events page$/ do
  visit events_path
end

When /^I go to the event list page for "([^"]*)"$/ do |list|
  visit events_path(list: list)
end