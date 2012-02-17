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

Then /^I should see that video's thumbnail$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the video's information should be loaded$/ do
  pending # express the regexp above with the code you wish you had
end