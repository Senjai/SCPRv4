#### Episode Creation
Given /^the program has (\d+) episodes?$/ do |num|
  @episodes = create_list :show_episode, num.to_i, show: @program, asset_count: 1
  @episode = @episodes[rand(@episodes.length)]
end

Given /^there (?:is|are) (\d+) episodes? with no segments$/ do |num|
  program = create :kpcc_program, episode_count: 1
  @episode = program.episodes.first
  @episode.segments.count.should eq 0
end


#### Finders
Then /^I should see a list of older episodes below the current episode$/ do
  page.should have_css ".show-episode", count: @program.episodes.count - 1
end

Then /^I should see the current episode's information$/ do
  page.find(".current-episode").should have_content @program.episodes.published.first.headline
end

Then /^I should see a list of the current episode's segments$/ do
  page.find(".current-episode-segments").should have_css(".story-headline", count: @program.episodes.published.first.segments.count)
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
When /^I go to an episode's page$/ do
  visit @episode.link_path
  current_path.should eq @episode.link_path
end

When /^I go to that episode's page$/ do
  visit @episode.link_path
  current_path.should eq @episode.link_path
end