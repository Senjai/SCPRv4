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

Then /^I should see the (\d+) most recently published videos in the pop\-up$/ do |num|
  @latest_videos = VideoShell.published.limit(num.to_i)
  find(".videos-overlay").should have_css ".list .video-thumb", count: num.to_i
end

Then /^there should be modal pagination$/ do
  find("button.arrow.right")['data-page'].should eq "2"
  find("button.arrow.left")['data-page'].should eq ""
  find(".pages").should have_content "1 of 2"
end

Then /^I should see that there is nothing to list in the pop\-up with the message "([^"]*)"$/ do |message|
  find(".videos-overlay .none-to-list").should have_content message
end

Then /^I should see different videos than the first page$/ do
  pending "FIXME Doesn't work properly"
  #find(".videos-overlay li.video-thumb:first-of-type").should_not have_content @latest_videos.first.short_headline
end

Then /^I should be on page 2 of the videos list$/ do
  pending "FIXME Selenium isn't waiting for the request to finish"
  # find(".pages").should have_content "2 of 2"
  # find("button.arrow.right")['data-page'].should eq ""
  # find("button.arrow.left")['data-page'].should eq "1"
end


#### Assertions
Then /^the latest videos section should not have the current video$/ do
  page.find(".latest-videos").should_not have_content VideoShell.published.first.short_headline
end



#### Actions
When /^I click on the Browse All Videos button$/ do
  click_button "browse-all-videos"
end

When /^I click the Next Page button$/ do
  click_button "next-page"
end


