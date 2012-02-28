Given /^there (?:is|are) (\d+) video shells?$/ do |num|
  @video_shells = create_list :video_shell, num.to_i
  @video_shell = @video_shells.first if @video_shells
  VideoShell.all.count.should eq num.to_i
end

When /^I go to that video's page$/ do
  visit video_path @video_shell
end

When /^I go to the video index page$/ do
  visit videos_path
end

Then /^I should see the most recently published video featured$/ do
  page.find("article>h1.story-headline").should have_content VideoShell.published.recent_first.first.headline
end

Then /^I should see that video's information$/ do
  page.should have_content @video_shell.headline
  page.should have_content @video_shell.body
  page.should have_content helper.render_byline @video_shell
end