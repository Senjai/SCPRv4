#### Finders
Then /^I should see the segment's information$/ do
  page.find(".segment article header").should have_content ShowSegment.last.headline
end

Then /^I should see a list of that program's segments$/ do
  page.should have_css ".teaser", count: @program.segments.count
end

#### Assertions
Then /^that section should not have the current segment listed$/ do
  page.find(@css_finder).should_not have_content @segment.headline
end


#### Routing
When /^I go to (?:that|the|a|any) segment's page$/ do
  @segment = ShowSegment.all[rand(ShowSegment.count)]
  visit @segment.link_path
  current_path.should eq @segment.link_path
end
