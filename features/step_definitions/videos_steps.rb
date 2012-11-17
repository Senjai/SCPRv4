#### Setup
Given /^there (?:is|are) (\d+) video shells?$/ do |num|
  @video_shells = create_list :video_shell, num.to_i, asset_count: 1
  @video_shell = @video_shells[rand(@video_shells.size)]
  VideoShell.all.count.should eq num.to_i
end


#### Routing
When /^I go to that video's page$/ do
  visit @video_shell.link_path
end

When /^I go to the videos page$/ do
  visit video_index_path
end

When /^I go to the page for one of the videos$/ do
  visit @video_shell.link_path
end


#### Finders
Then /^I should see the most recently published video featured$/ do
  page.find("article header").should have_content VideoShell.published.first.headline
end

Then /^I should see that video featured$/ do
  page.find("article header").should have_content @video_shell.headline
end

Then /^I should see a section with the (\d+) most recently published videos$/ do |num|
  page.find(".latest-videos .list").should have_css ".video-thumb", count: num.to_i
end

#### Assertions
Then /^the latest videos section should not have the current video$/ do
  page.find(".latest-videos").should_not have_content VideoShell.published.first.short_headline
end
