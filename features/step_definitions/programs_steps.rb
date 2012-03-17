#### Setup
Given /^there (?:is|are) (\d+) kpcc programs?$/ do |num|
  @programs = create_list :kpcc_program, num.to_i
  @program = @programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^there (?:is|are) (\d+) other programs?$/ do |num|
  @programs = create_list :other_program, num.to_i
  @program = @programs[rand(@programs.length)]
  OtherProgram.all.count.should eq num.to_i
end

Given /^there (?:is|are) (\d+) segment\-style kpcc programs?$/ do |num|
  @programs = create_list :kpcc_program, num.to_i, display_segments: true, display_episodes: false
  @program = @programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^there (?:is|are) (\d+) episodic\-style kpcc programs?$/ do |num|
  @programs = create_list :kpcc_program, num.to_i, display_segments: false, display_episodes: true
  @program = @programs[rand(num.to_i)]
  KpccProgram.all.count.should eq num.to_i
end

Given /^a program titled "([^"]*)" with slug "([^"]*)"$/ do |title, slug|
  @program = create :kpcc_program, title: title, slug: slug
end

Given /^there (?:is|are) (\d+) other programs? with a podcast and no RSS$/ do |num|
  @programs = create_list :other_program, num.to_i, rss_url: ""
  @program = @programs[rand(@programs.length)]
  @program.rss_url.should be_blank
  @program.podcast_url.should be_present
end

Given /^there (?:is|are) (\d+) other programs? with an RSS and no podcast$/ do |num|
  @programs = create_list :other_program, num.to_i, podcast_url: ""
  @program = @programs[rand(@programs.length)]
  @program.rss_url.should be_present
  @program.podcast_url.should be_blank
end

Given /^there (?:is|are) (\d+) other programs? with no RSS and no podcast$/ do |num|
  @programs = create_list :other_program, num.to_i, podcast_url: "", rss_url: ""
  @program = @programs[rand(@programs.length)]
  @program.rss_url.should be_blank
  @program.podcast_url.should be_blank
end

Given /^the following programs:$/ do |table|
  @programs = []
  table.hashes.each do |attributes|
    @programs << create(:kpcc_program, slug: attributes[:slug], title: attributes[:title])
  end
  KpccProgram.count.should eq table.hashes.count
end


#### Finders
Then /^I should see the program's information$/ do
  find(".show-title h1").should have_content @program.title
end

Then /^I should see a headshot of the program's host$/ do
  page.should have_xpath("//div[contains(@class, '#{@program.slug}')]") # TODO: Need to figure out how to actually check for background-image attribute.
end

Then /^I should see a list of that program's podcast entries$/ do
  page.should have_css ".teaser" # TODO: Need a better way to test this
end

Then /^I should see a list of that program's RSS entries$/ do
  page.should have_css ".teaser" # TODO: Need a better way to test this
end

Then /^I should not see any podcast entries$/ do
  # page.should_not have_content "<h2>Recently</h2>" # TODO: Need a better way to test this
end

Then /^I should not see any RSS entries$/ do
  # page.should_not have_content "<h2>Latest News</h2>" # TODO: Need a better way to test this
end

Then /^I should not see any programs$/ do
  page.should_not have_css ".programs-list"
  page.should_not have_css "#featured-programs .headshot"
end

Then /^I should see the featured programs in the correct order$/ do
  @programs.each do |program|
    page.find("#featured-programs li.#{program.slug}").should have_content program.title
  end
end


#### Assertions
Given /^the program is currently on$/ do
  schedule = create :schedule, kpcc_program_id: @program.id, program: @program.title
  Schedule.stub(:on_now) { schedule }
  Schedule.on_now.programme.should eq @program
end

#### Utility
Given /^its feeds are cached$/ do
  @program.cache.should be_true
  Rails.cache.fetch("ext_program:#{@program.slug}:podcast").should_not be_blank if @program.podcast_url.present?
  Rails.cache.fetch("ext_program:#{@program.slug}:rss").should_not be_blank if @program.rss_url.present?
end


#### Routing
When /^I go to the programs page$/ do
  visit programs_path
  current_path.should eq programs_path
end

When /^I go to (?:the|a) program's page$/ do
  visit program_path @program
  current_path.should eq program_path @program
end