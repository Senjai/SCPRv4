#### Setup
Given /^(?:an )?events? with the following attributes?:$/ do |table|
  events = []
  table.hashes.each do |attributes|
    attributes["starts_at"] = Chronic.parse(attributes["starts_at"]) if attributes["starts_at"].present?
    events << create(:event, :published, attributes)
  end
  events.count.should eq table.hashes.count
  @event = events[rand(events.count)]
end

#### Finders
Then /^I should see a list of (\d+) upcoming events$/ do |num|
  Event.upcoming.limit(num.to_i).each_with_index do |event|
    page.should have_content event.headline
  end
end

Then /^I should see a list of (\d+) upcoming "([^"]*)" events$/ do |num, list|
  Event.upcoming.limit(num.to_i).send(list.to_sym).each_with_index do |event|
    page.should have_content event.headline
  end
end

Then /^I should see (\d+) unpublished events$/ do |num|
  Event.limit(num.to_i).where(is_published: false).each do |event|
    page.should match event.headline
  end
end

Then /^I should see (\d+) past events$/ do |num|
  if num.to_i == 0
    page.should_not have_css ".past-events .event"
  else
    page.should have_css ".past-events .event", count: num.to_i
  end
  # Event.limit(num.to_i).past.forum.each_with_index do |event, i|
  #   page.find(".past-events .event")[i].should have_content event.headline
  # end
end

#### Routing
When /^I go to the events page$/ do
  visit events_path
end

When /^I go to (?:that|the|an) event's page$/ do
  visit @event.link_path
end
