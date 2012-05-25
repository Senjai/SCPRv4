#### Setup
Given /^(?:an )?episodes? with the following attributes?:$/ do |table|
  @episodes = []
  table.hashes.each do |attributes|
    @episodes << create(:show_episode, attributes)
  end
  @episode = @episodes[rand(table.hashes.count)]
end


#### Finders
Then /^I should see a list of older episodes below the current episode$/ do
  page.should have_css ".show-episodes .episode", count: KpccProgram.last.episodes.count - 1
end

Then /^I should see the current episode's information$/ do
  page.find(".current-episode").should have_content KpccProgram.last.episodes.published.first.headline
end

Then /^I should see a list of the current episode's segments$/ do
  page.find(".current-episode-segments").should have_css(".story-headline", count: KpccProgram.last.episodes.published.first.segments.count)
end

Then /^I should see each episode's primary asset$/ do
  page.should have_css ".show-episode .contentasset img"
end

Then /^I shouldn't see anything about episodes$/ do
  page.should_not have_css ".show-episode"
  page.should_not have_css ".show-episodes"
  page.should_not have_css ".current-episode"
  page.should_not have_css ".upcoming-episode"
end

Then /^I should see the episode's primary asset$/ do
  page.should have_css ".episode .contentasset img"
end

Then /^I should not see the archive select$/ do
  page.should_not have_css ".archive-select"
end


#### Actions
When /^I select a date that doesn't exist for an episode in the archive select$/ do
  @episode = @program.episodes.last
  bad_date = @episode.air_date - 1
  page.select bad_date.strftime("%B"), from: "archive_date_2i" # Month
  page.select bad_date.strftime("%d"), from: "archive_date_3i" # Day
  page.select bad_date.strftime("%Y"), from: "archive_date_1i" # Year
end

When /^I select the date for th(?:at|ose) episodes? in the archive select$/ do
  @episode = @program.episodes.last
  page.select @episode.air_date.strftime("%B"), from: "archive_date_2i" # Month
  page.select @episode.air_date.strftime("%-d"), from: "archive_date_3i" # Day
  page.select @episode.air_date.strftime("%Y"), from: "archive_date_1i" # Year
end


#### Routing
When /^I go to (?:the|an|that) episode's page$/ do
  episode = ShowEpisode.last
  visit episode.link_path
  current_path.should eq episode.link_path
end

Then /^I should be on (?:the|that) episode's page$/ do
  current_path.should eq @episode.link_path
end