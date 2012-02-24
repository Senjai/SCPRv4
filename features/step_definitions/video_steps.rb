Given /^there (?:is|are) (\d+) videos?$/ do |num|
  if num.to_i == 1
    @video_shell = create :video_shell
  else
    @video_shells = create_list :video_shell, num.to_i
  end
end

When /^I go to that video's page$/ do
  visit video_path @video_shell
end

When /^I go to the video index page$/ do
  visit videos_path
end

Then /^I should see the latest video featured$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see that video's information$/ do
  page.should have_content @video_shell.headline
  page.should have_content @video_shell.body
  page.should have_content helper.render_byline @video_shell
end