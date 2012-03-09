Given /^there (?:is|are) (\d+) kpcc programs?$/ do |num|
  @kpcc_programs = create_list :kpcc_program, num.to_i
  @kpcc_program = @kpcc_programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^there (?:is|are) (\d+) other programs?$/ do |num|
  @other_programs = create_list :other_program, num.to_i
  @other_program = @other_programs[rand(@other_programs.length)]
  OtherProgram.all.count.should eq num.to_i
end

Given /^there (?:is|are) (\d+) segment\-style kpcc programs?$/ do |num|
  @kpcc_programs = create_list :kpcc_program, num.to_i, display_segments: true, display_episodes: false
  @kpcc_program = @kpcc_programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^there (?:is|are) (\d+) episodic\-style kpcc programs?$/ do |num|
  @kpcc_programs = create_list :kpcc_program, num.to_i, display_segments: false, display_episodes: true
  @kpcc_program = @kpcc_programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^the program has (\d+) segments?$/ do |num|
  @segments = create_list :show_segment, num.to_i, show: @kpcc_program, asset_count: 1
  @segment = @segments[rand(@segments.length)]
end

Then /^I should see each episode's primary asset$/ do
  page.should have_css ".show-episode .contentasset img"
end

Then /^I should see each segment's primary asset$/ do
  page.should have_css ".segment-teaser .contentasset img"
end

Given /^the program has (\d+) episodes?$/ do |num|
  @episodes = create_list :show_episode, num.to_i, show: @kpcc_program, asset_count: 1
end

Given /^each episode has (\d+) segments?$/ do |num|
  @kpcc_program.episodes.each do |episode|
    segments = create_list :show_segment, num.to_i
    segments.each do |segment|
      create_list :show_rundown, num.to_i, episode: episode, segment: segment
    end
  end
end

When /^I go to the programs page$/ do
  visit programs_path
end

Given /^a program titled "([^"]*)" with slug "([^"]*)"$/ do |title, slug|
  @kpcc_program = create :kpcc_program, title: title, slug: slug
end

When /^I go to the program's page$/ do
  visit program_path @kpcc_program
end

Then /^I should see the program's information$/ do
  find(".show-title h2").should have_content @kpcc_program.title
end

Then /^I should see a headshot of the program's host$/ do
  page.should have_xpath("//div[contains(@class, '#{@kpcc_program.slug}')]") # Need to figure out how to actually check for background-image attribute.
end

When /^I go to a program's page$/ do
  visit program_path @kpcc_program
end

Then /^I should see a list of segments$/ do
  page.should have_css ".segment-teaser", count: @kpcc_program.segments.count
end

Then /^I should see a list of episodes$/ do
  page.should have_css ".show-episode", count: @kpcc_program.episodes.count
end

Then /^I should see the current episode's information$/ do
  page.find(".current-episode").should have_content @kpcc_program.episodes.published.first.headline
end

Then /^I should see a list of the current episode's segments$/ do
  page.find(".current-episode").should have_css(".story-headline", count: @kpcc_program.episodes.published.first.segments.count)
end
