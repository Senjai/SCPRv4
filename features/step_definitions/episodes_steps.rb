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


#### Routing
When /^I go to (?:the|an|that) episode's page$/ do
  episode = ShowEpisode.last
  visit episode.link_path
  current_path.should eq episode.link_path
end
